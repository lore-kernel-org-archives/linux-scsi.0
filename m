From: "Surekha.PC" <surekhap@cisco.com>
Subject: RE: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 29 Oct 2003 18:53:43 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <018b01c39e1f$e013bab0$a0074d0a@apac.cisco.com>
References: <20031027153932.A16679@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:55934 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S262063AbTJ2NXz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 08:23:55 -0500
In-Reply-To: <20031027153932.A16679@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, davmyers@cisco.com


Hi,

 I have interspersed my answers below for 2 of your comments.

>	- kill the is_root_disk special casing.  drivers can't know
>	what the root disks is, there might not even be a single one.

This flag is needed for our iSCSI network boot implementation to check
if we are booted on iSCSI disk. This is used while trying to shutdown
the iSCSI service.
	
>	- what the heck is iscsi_set_if_addr?  You have absolutely no
business
>	messing with network device configuration.

This is again needed for network boot. The n/w driver and iSCSI driver
are loaded during early boot. Since the n/w interface is not setup at
that time, we need to bring up the interface through this call in iSCSI
driver.

Thanks,
surekha
 

	

