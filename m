From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: driverfs is not for everything! (was: [PATCH] /proc/scsi/map )
Date: Mon, 24 Jun 2002 14:09:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206241809.g5OI9Ds02886@localhost.localdomain>
References: <andrew.grover@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id LAA01509
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jun 2002 11:09:20 -0700
In-Reply-To: Message from "Grover, Andrew" <andrew.grover@intel.com>
   of "Mon, 24 Jun 2002 10:35:53 PDT." <59885C5E3098D511AD690002A5072D3C02AB7F53@orsmsx111.jf.intel.com>
List-Id: linux-scsi@vger.kernel.org
To: "Grover, Andrew" <andrew.grover@intel.com>
Cc: 'David Brownell' <david-b@pacbell.net>, 'Nick Bellinger' <nickb@attheoffice.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>

andrew.grover@intel.com said:
> If a device can be accessed by multiple machines concurrently, it
> should not be in driverfs. 

On that argument, we'll eliminate almost all Fibre Channel devices!

I think the qualification for appearing in driverfs is actually possessing a 
driver.  Therefore, we accept FC and iSCSI.  Things which appear as 
FileSystems are debatable, but not anything which has a real device driver.

> We need a device tree to do PM. If driverfs's PM capabilities are hurt
> because it doesn't stay true to that, then the featureitis has gone
> too far. 

Perhaps it's more a question of whether power management belongs as an every 
unit item in driverfs.  As you say, we get problems where the device is shared 
between multiple computers.

James


