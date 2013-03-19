class Employee
  attr_accessor :name, :title, :salary, :boss

  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
    @boss = nil
  end

  def calculate_bonus(multiplier)
    @bonus = self.salary * multiplier
  end
end


class Manager < Employee
  attr_accessor :employees_assigned

  def initialize(name, title, salary)
    super(name, title, salary)
    self.employees_assigned = []
  end

  def assign_employee(employee)
    employees_assigned << employee
    employee.boss = self
  end

  def calculate_bonus(multiplier)
    self.total_employees_salary * multiplier
  end

  def total_employees_salary
    total = 0
    self.employees_assigned.each do |employee|
      if employee.class == Manager
        total += employee.total_employees_salary
      end
      total += employee.salary
    end
    total
  end
end

bob = Employee.new("Bob", "Janitor", 5)
eric = Employee.new("Eric", "Janitor", 5)
sally = Manager.new("Sally", "Head Janitor", 50)
jon = Manager.new("Jon", "Big Boss", 500)

sally.assign_employee(bob)
sally.assign_employee(eric)
jon.assign_employee(sally)
