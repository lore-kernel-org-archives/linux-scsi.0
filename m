From: Andrew Morton <akpm@digeo.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Thu, 24 Oct 2002 21:40:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DB8CB39.AD55D84@digeo.com>
References: <3DB8A0CC.1804DF79@digeo.com> <20021025040659.GB3556@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id VAA00098
	for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2002 21:40:26 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Badari Pulavarty <pbadari@us.ibm.com>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Jens Axboe <axboe@suse.de>

Doug Ledford wrote:
> 
> Anyway, I've got all my current updates pushed to
> linux-scsi.bkbits.net/scsi-misc-2.5 and I know James and Patrick have some
> fixes in there as well.

OK, thanks.  Could someone please extract a diff which we can try out?
