# -*- coding: undecided -*-
module Observable

  def store_hook
    notify_observers
  end

  def subscribe(object, method)
    (@observers ||= []) << {:object =>object, :method => method}
  end

  def unsubscribe(obj)
    @observers.reject! {|obs| obs[:object].equal? obj}
  end

  def notify_observers
    (@observers ||= []).each {|obs| obs[:object].send(obs[:method], self)}
  end
  
end
