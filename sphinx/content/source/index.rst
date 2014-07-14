Source
======

Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,

Doxygen inegration with Breathe
-------------------------------

.. doxygenclass:: alpha::Calculator
   :members:

UML diagrams with PlantUML
--------------------------

Sequence
~~~~~~~~

.. uml::

    participant User

    User -> A: DoWork
    activate A

    A -> B: << createRequest >>
    activate B

    B -> C: DoWork
    activate C
    C --> B: WorkDone
    destroy C

    B --> A: RequestCreated
    deactivate B

    A -> User: Done
    deactivate A

Usecase
~~~~~~~

.. uml::

    (Use the application) as (Use)

    User -> (Start)
    User --> (Use)

    Admin ---> (Use)

    note right of Admin : This is an example.

    note right of (Use)
      A note can also
      be on several lines
    end note

    note "This note is connected\nto several objects." as N2
    (Start) .. N2
    N2 .. (Use)

Class
~~~~~

.. uml::

    class BaseClass

    namespace net.dummy {
        .BaseClass <|-- Person
        Meeting o-- Person

        .BaseClass <|- Meeting
    }

    namespace net.foo {
      net.dummy.Person  <|- Person
      .BaseClass <|-- Person

      net.dummy.Meeting o-- Person
    }

    BaseClass <|-- net.unused.Person
