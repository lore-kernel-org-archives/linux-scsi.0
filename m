From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH RFC 0/3] SCSI Userspace Target
Date: Fri, 27 Jan 2006 15:54:13 +0100
Message-ID: <20060127145413.GP4311@suse.de>
References: <1138157882.11692.31.camel@max> <20060125174649.GH14225@havoc.gtf.org> <43D9F9E9.3060701@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:42355 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1751468AbWA0Oza (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2006 09:55:30 -0500
Content-Disposition: inline
In-Reply-To: <43D9F9E9.3060701@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On Fri, Jan 27 2006, Mike Christie wrote:
> packet socket for example. Is bsg still being worked on? Is it going to 
> use a new interface or is it ioctl based like block/scsi_ioctl.c?

bsg supports both SG_IO and read/write like the SCSI sg does. It should
be pretty complete, it's been a while since I worked on it. I thought I
had it in -git somewhere, I'll get it added.

-- 
Jens Axboe

