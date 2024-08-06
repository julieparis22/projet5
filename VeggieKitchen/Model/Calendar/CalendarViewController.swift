//
//  CalendarViewController.swift
//  VeggieKitchen
//
//  Created by julie ryan on 05/08/2024.
//

import UIKit
import EventKit

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let calendarManager = CalendarManager()
    private var events: [EKEvent] = []
    private var errorMessage: String?
    
    private let tableView = UITableView()
    let startDate: Date
    let endDate: Date
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchEvents()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
        
        // Registering cell with subtitle style
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
    }
    
    private func fetchEvents() {
        calendarManager.requestCalendarAccess { granted, error in
            if granted {
                self.calendarManager.fetchEvents(startDate: self.startDate, endDate: self.endDate) { fetchedEvents, error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    } else {
                        self.events = fetchedEvents ?? []
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                self.errorMessage = error?.localizedDescription ?? "Accès au calendrier refusé."
                DispatchQueue.main.async {
                    self.showErrorAlert()
                }
            }
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Erreur", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        
        let event = events[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        cell.textLabel?.text = """
        \(String(describing: event.title))
        Début: \(dateFormatter.string(from: event.startDate))
        Fin: \(dateFormatter.string(from: event.endDate))
        Notes: \(event.notes ?? "Aucune note")
        """
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let eventToDelete = events[indexPath.row]
            calendarManager.deleteEvent(eventToDelete) { success, error in
                if success {
                    self.events.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                } else {
                    print("Erreur lors de la suppression de l'événement: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
}
