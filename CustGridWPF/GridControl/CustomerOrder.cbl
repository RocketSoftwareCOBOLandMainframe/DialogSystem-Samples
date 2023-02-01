       class-id CustomerOrder attribute ComVisible(false).

       working-storage section.

      *> Expose a bunch of public properties matching the data we want to expose in the data grid
       01 _orderNo         binary-long property as     "OrderNo"  .
       01 _orderDate       type DateTime property as   "OrderDate".
       01 _orderValue      decimal property as         "OrderValue".
       01 _paymentValue    decimal property as         "PaymentValue".
       01 _balance         decimal property as         "Balance".

      *> Our backing store must have a default constructor
       method-id New.
       procedure division.
       end method.

       method-id New.
       local-storage section.
       procedure division using by value orderData as object occurs any.
       
           invoke self::InitializeData(orderData)
           goback.
       end method.
       
       method-id New.
       local-storage section.
       procedure division using by value orderNo as binary-long, 
                                         orderDate as type DateTime, 
                                         orderValue as decimal, 
                                         paymentValue as decimal, 
                                         balance as decimal.

           move orderNo to _orderNo
           move orderDate to _orderDate
           move orderValue to _orderValue
           move paymentValue to _paymentValue
           move balance to _balance

           goback.
       end method.

       method-id InitializeData.
       01 i binary-long.
       01 itemcount binary-long.
       01 val decimal.
       procedure division using by value orderData as object occurs any.
           *> Iterate over the passed data and initialize each of our properties
           move size of orderData to itemcount
           perform varying i from 1 by 1 until i > itemcount
           
               evaluate i
                   when 1
                        invoke binary-long::TryParse(orderData(1) as string, _orderNo)
                   when 2
                        if (orderData(2) instance of type DateTime)
                            move orderData(2) as type DateTime to _orderDate
                        end-if
                   when 3
                        invoke decimal::TryParse(orderData(3)::ToString(), _orderValue)
                   when 4
                        invoke decimal::TryParse(orderData(4)::ToString(), _paymentValue)
                   when 5
                        if (decimal::TryParse(orderData(5)::ToString(), val) = TRUE)
                           set self::Balance to val
                        end-if
               end-evaluate
           
           end-perform
           goback.
       end method.

      *>> <summary>
      *>> Returns the Customer Order data as an Array
      *>> </summary>
      *>> <returns></returns>
       method-id. AsArray.
       01 val float-short.
       procedure division returning arr as object occurs any.
           set size of arr to 5
           set arr(1) to string::Format("{0, 6}", self::OrderNo::ToString())
           set arr(2) to self::OrderDate
           if (float-short::TryParse( self::OrderValue::ToString(), by reference val))
               set arr(3) to val
           end-if
           if (float-short::TryParse( self::PaymentValue::ToString(), by reference val))
               set arr(4) to val
           end-if
           if (float-short::TryParse( self::Balance::ToString(), by reference val))
               set arr(5) to val
           end-if
       end method.
       
       end class.
