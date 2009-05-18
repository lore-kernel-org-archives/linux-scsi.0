From: David Miller <davem@davemloft.net>
Subject: Re: [net-next-2.6 PATCH 01/11] ixgbe: Add FCoE Storage MAC Address
 support
Date: Sun, 17 May 2009 21:08:37 -0700 (PDT)
Message-ID: <20090517.210837.159641601.davem@davemloft.net>
References: <20090517223213.14124.61405.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20090517223213.14124.61405.stgit@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
To: jeffrey.t.kirsher@intel.com
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, peter.p.waskiewicz.jr@intel.com, yi.zou@intel.com
List-Id: linux-scsi@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Sun, 17 May 2009 15:32:25 -0700

> This patch implements the Storage Address entrypoint from the net device.
> It will read the SAN MAC addresses from the EEPROM of the 82599 hardware,
> and make them available to the FCoE stack through the net device.
> 
> Also, add/del the SAN MAC address to the netdev dev_addr_list via the
> kernel api dev_addr_add()/dev_addr_del() when there is a valid SAN MAC
> supported by the HW.
> 
> Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> Signed-off-by: Yi Zou <yi.zou@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

All 11 patches applied to net-next-2.6

Thanks!
