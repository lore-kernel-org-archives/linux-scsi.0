From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] netdev: storage address support
Date: Mon, 27 Apr 2009 03:01:03 -0700 (PDT)
Message-ID: <20090427.030103.88777540.davem@davemloft.net>
References: <20090424080349.30460.73770.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46688
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752006AbZD0KBK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Apr 2009 06:01:10 -0400
In-Reply-To: <20090424080349.30460.73770.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeffrey.t.kirsher@intel.com
Cc: netdev@vger.kernel.org, gospo@redhat.com, linux-scsi@vger.kernel.org, christopher.leech@intel.com

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri, 24 Apr 2009 01:03:50 -0700

> 2) Server Provided MAC Address (SPMA)
> The server indicates to the FCF the address it would like to use for FCoE
> traffic.  It's expected that SPMA capable interfaces will have a storage
> dedicated MAC address programed into EPROM, flash, or other non-volatile
> storage which the driver will be able to provide to the FCoE stack.
> 
> This adds a net_device_ops function to query a driver for a dedicated storage
> address.
> 
> If ndo_get_storage_address is implemented, then the address will also be
> exposed as a sysfs attribute.  In order to do that, a new optional attrs group
> is added to the net_device, with the visibility of each attribute protected by
> a call to netdev_show_optional_attr().

This should be what is currently provided in netdev->perm_addr[]

I really see no difference.
