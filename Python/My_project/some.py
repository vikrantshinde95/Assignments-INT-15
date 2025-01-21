def bookTicket(self):
    self.source = input("Enter your source: ") 
    self.destination = input("Enter your destination: ") 
    try:
        if self.lg_status:
            if self.source.isalpha() and self.destination.isalpha():
                print( f"Ticket confirmed from {self.source.title()} to {self.destination.title()}" )
            else: raise ValueError("Source and destination must be valid city names") 
        else: raise Exception("User not logged in") 
             
    except Exception as e: 
        print(e)


