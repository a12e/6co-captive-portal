defmodule Pwc.Firewall do
  require Logger
  
  @iptables_chain "PWC"
  @disallow_time 3600

  @spec allow_mac(mac_address :: String.t) :: no_return
  def allow_mac(mac_address) do
    {result, exit_code} = System.cmd "sudo", String.split("--non-interactive /sbin/iptables -t nat --insert #{@iptables_chain} -i wlan0 -p tcp -m tcp --dport 80 -m mac --mac-source #{mac_address} -j RETURN")
    System.cmd "sudo", String.split("--non-interactive /sbin/iptables -t filter --insert #{@iptables_chain} -m mac --mac-source #{mac_address} -j RETURN")
    System.cmd "sudo", String.split("--non-interactive /sbin/ip6tables -t filter --insert #{@iptables_chain} -m mac --mac-source #{mac_address} -j RETURN")
    
    if exit_code === 0 do
      Logger.info "Allowed #{mac_address} to go through firewall"
      # On retire la MAC au bout d'un certain temps
      Task.async(fn() -> 
        :timer.sleep @disallow_time*1000
        disallow_mac mac_address
      end)      
    else
      Logger.error "Failure allowing #{mac_address} to go through firewall"
      Logger.error result
    end
  end
  
  @spec disallow_mac(mac_address :: String.t) :: no_return
  def disallow_mac(mac_address) do
    {result, exit_code} = System.cmd "sudo", String.split("--non-interactive /sbin/iptables -t nat --delete #{@iptables_chain} -i wlan0 -p tcp -m tcp --dport 80 -m mac --mac-source #{mac_address} -j RETURN")
    System.cmd "sudo", String.split("--non-interactive /sbin/iptables -t filter --delete #{@iptables_chain} -m mac --mac-source #{mac_address} -j RETURN")
    System.cmd "sudo", String.split("--non-interactive /sbin/ip6tables -t filter --delete #{@iptables_chain} -m mac --mac-source #{mac_address} -j RETURN")    
    
    if exit_code === 0 do
      Logger.info "Disallowed #{mac_address} to go through firewall"
    else
      Logger.error "Failure disallowing #{mac_address} to go through firewall"
      Logger.error result    
    end
  end
  
  @spec is_mac_allowed(mac_address :: String.t) :: boolean
  def is_mac_allowed(mac_address) do
    {_result, exit_code} = System.cmd "sudo", String.split("--non-interactive /sbin/iptables -t nat --check #{@iptables_chain} -i wlan0 -p tcp -m tcp --dport 80 -m mac --mac-source #{mac_address} -j RETURN")
    
    case exit_code do
      0 -> true
      _ -> false
    end
  end
end
