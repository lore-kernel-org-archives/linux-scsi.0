From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Sun, 27 Oct 2002 15:37:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210272137.g9RLbW413689@localhost.localdomain>
References: <axboe@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id NAA31694
	for <linux-scsi@vger.kernel.org>; Sun, 27 Oct 2002 13:37:42 -0800
In-Reply-To: Message from Jens Axboe <axboe@suse.de>
   of "Sun, 27 Oct 2002 22:20:35 +0100." <20021027212035.GM3966@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Badari Pulavarty <pbadari@us.ibm.com>, Andrew Morton <akpm@digeo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Doug Ledford <dledford@redhat.com>

axboe@suse.de said:
> Sure that would suffice, but lets just move to the prep approach right
> away. First just the global one, later we can do one per device type. 

OK, will do.  SCSI currently needs the ability to bail on a request 
preparation in such a way that the request will get re-queued for preparation 
(out of command blocks or other resource shortage), which I believe you're 
working on.

The per device type is more tricky because SCSI can have more than one upper 
level driver driving the device queue.

James


