From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Fri, 25 Oct 2002 09:16:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210251416.g9PEGxv01952@localhost.localdomain>
References: <akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA16671
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2002 07:17:11 -0700
In-Reply-To: Message from Andrew Morton <akpm@digeo.com>
   of "Thu, 24 Oct 2002 18:39:24 PDT." <3DB8A0CC.1804DF79@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Badari Pulavarty <pbadari@us.ibm.com>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Jens Axboe <axboe@suse.de>, Doug Ledford <dledford@redhat.com>

This has all the hallmarks of the Qlogic double done bug:  Under certain high 
stress/bad bus situations, the Qla driver will call done twice on a SCSI 
command structure.  I take it this is the 6.1.0 qla driver, which qlogic has 
assured me "really really" has this bug fixed?

Is there any way to switch adapters to see if we can confirm this hypothesis?

James


