From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.4.19 scsi_rescan patch (2nd pass)
Date: Wed, 02 Oct 2002 11:34:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210021534.g92FYh002462@localhost.localdomain>
References: <andrew.r.cress@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA21975
	for <linux-scsi@vger.kernel.org>; Wed, 2 Oct 2002 08:34:50 -0700
In-Reply-To: Message from "Cress, Andrew R" <andrew.r.cress@intel.com>
   of "Wed, 02 Oct 2002 07:52:16 PDT." <A5974D8E5F98D511BB910002A50A66470580D24F@hdsmsx103.hd.intel.com>
List-Id: linux-scsi@vger.kernel.org
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: linux-scsi@vger.kernel.org

andrew.r.cress@intel.com said:
> Here is a 2nd pass at a patch to do a scsi rescan so that hot-inserted
> scsi disks can automatically be recognized.  It includes some
> recommended changes/cleanup from Patrick and Mike. 

Is there a really good reason we can't use the hotplug infrastructure for this 
and scan from user level?  I know the 2.4 hotplug is less well developed than 
2.5, but I believe it will work well enough for this.

If you go the hotplug route, all we need is a hook to trigger the SCSI hotplug 
event.

James


