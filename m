From: Andrew Morton <akpm@digeo.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Fri, 25 Oct 2002 15:18:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DB9C318.5874F2C9@digeo.com>
References: Message from Jens Axboe <axboe@suse.de>
	   of "Fri, 25 Oct 2002 21:47:12 +0200." <20021025194712.GC1203@suse.de> <200210252214.g9PMEhD04705@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id PAA20081
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2002 15:18:02 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <axboe@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Badari Pulavarty <pbadari@us.ibm.com>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Doug Ledford <dledford@redhat.com>

James Bottomley wrote:
> 
> Unfortunately, the **** dump_stack()
> doesn't print a trace so I still don't know where the command is coming from.

hrm.  Why not?   Maybe there's a BUG happening as well and that
fiddles the console log level?

Did you try using BUG instead of dump_stack()?
