From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi sysfs update 3
Date: Thu, 28 Nov 2002 13:17:09 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211281917.gASJH9c05479@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id LAA19317
	for <linux-scsi@vger.kernel.org>; Thu, 28 Nov 2002 11:17:14 -0800
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Tue, 26 Nov 2002 23:11:01 PST." <20021127071100.GC1353@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

andmike@us.ibm.com said:
> I have attached an updated combined patch of my previously posted
> sysfs changes.  

I'm getting ready to put this in scsi-misc-2.5

I have misgivings about the removal of the scsi bus type, but I know looking 
at scsi host adapters as bridges isn't a universal view point.

James


