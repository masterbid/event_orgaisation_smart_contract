pragma solidity ^0.5.4;

contract EventContract {
    struct Event {
        address admin;
        string name;
        uint price;
        uint ticketCount;
        uint ticketRemaining;
    }
    mapping(uint => Event) events;
    mapping(address => mapping(uint => uint)) public tickets;
    uint public nextId;
    
    function createEvent(
        string calldata name,
        uint date,
        uint price,
        uint ticketCount
        ) external {
            require(date > now, 'event can only be organized in the future');
            require(ticketCount > 0, 'can only create event with atleast 1 ticket available');
            events[nextId] = Event(
                msg.sender,
                name,
                price, 
                ticketCount,
                ticketcount
            );
            nextId++;
        }
        
    function buyTicket(uint id, uint quantity)
        payable 
        external 
        eventExist(id)
        eventActive(id) {
        Event storage _event = events[id];
        require(msg.value == (_event.price * quantity), 'not enough ether sent');
        require(_event.ticketRemaining >= quantity, 'not enough ticket left');
        _event.ticketRemaining -= quantity;
        tickets[msg.sender][id] += quantity;
    }
    
    function transferTicket(uint eventId, uint quantity, address to)
    external
    eventExist(eventId)
    eventActive(eventId) {
        require(tickets[msg.sender][eventId] >= quantity, 'not enough tickets');
        tickets[msg.sender][eventId] -= quantity;
        tickets[to][eventId] += quantity;
    }
    
    modifier eventExist(uint id) {
        require(events[id].date != 0, 'this event does not exist');
        _;
    }
    
    modifier eventActive(uint id) {
        require(now < events[id].date, 'this event is not active anymore');
        _;
    }
}