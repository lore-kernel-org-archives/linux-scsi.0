From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.4.19 scsi_rescan patch (2nd pass)
Date: Wed, 02 Oct 2002 12:29:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210021629.g92GT1G02805@localhost.localdomain>
References: <andrew.r.cress@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA02107
	for <linux-scsi@vger.kernel.org>; Wed, 2 Oct 2002 09:29:06 -0700
In-Reply-To: Message from "Cress, Andrew R" <andrew.r.cress@intel.com>
   of "Wed, 02 Oct 2002 09:26:17 PDT." <A5974D8E5F98D511BB910002A50A66470580D250@hdsmsx103.hd.intel.com>
List-Id: linux-scsi@vger.kernel.org
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: linux-scsi@vger.kernel.org

andrew.r.cress@intel.com said:
> I had been trying to do that with a user-level daemon I've written
> (sgraidmon at scsirastools.sf.net), but I can't rescan from user level
> because the new devices aren't attached to any /dev, so the user-level
> can't detect that a new device has been inserted, and it doesn't have
> any way to detect which device it might be.   

Right, that's why the hotplug event has to carry enough information to allow 
the script to identify what needs to be scanned (i.e. SCSI hostadapter number 
and PUN if possible). the scsi add-single-device mechanism can then be used to 
do the attachment (and scanning).

James




