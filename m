From: Uprooter <uprooter@gmail.com>
Subject: Re: Fusion MPT Ultra320 disks  detected as Ultra2
Date: Mon, 14 Dec 2009 21:58:59 +0200
Message-ID: <200912142158.59141.uprooter@gmail.com>
References: <26761757.post@talk.nabble.com> <200912131258.27052.uprooter@gmail.com> <1260705043.2709.285.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49222 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131AbZLNT6k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2009 14:58:40 -0500
Received: by bwz27 with SMTP id 27so2363022bwz.21
        for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2009 11:58:36 -0800 (PST)
In-Reply-To: <1260705043.2709.285.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

On Sunday 13 December 2009 13:50:42 James Bottomley wrote:
> On Sun, 2009-12-13 at 12:58 +0200, Uprooter wrote:
> > Hello James and thanks for trying to help.
> >
> > Unfortunately changing min_period  didn't solve anything.
> > # pwd
> > /sys/class/spi_transport/target2:0:1
> >
> > localhost target2:0:1 # echo 25 > min_period
> > localhost target2:0:1 # echo 1 > revalidate
> > I did it for both disks.
> > #dmesg | tail -10
> > target2:0:0: Beginning Domain Validation
> >  target2:0:0: Domain Validation skipping write tests
> >  target2:0:0: Ending Domain Validation
> >  target2:0:0: Beginning Domain Validation
> >  target2:0:0: Domain Validation skipping write tests
> >  target2:0:0: Ending Domain Validation
> >  target2:0:1: Beginning Domain Validation
> >  target2:0:1: Domain Validation skipping write tests
> >  target2:0:1: Ending Domain Validation
> >  target2:0:1: Beginning Domain Validation
> >  target2:0:1: Domain Validation skipping write tests
> >  target2:0:1: Ending Domain Validation
> >
> > # cat min_period
> > 25
> > # cat period
> > 50
> 
> OK, so I'd suspect a cabling problem.  50ns is the minimum period for a
> single ended bus.  You have to move to LVD to get anything beyond.  I'd
> say something in your SCSI cable chain is keeping the bus SE.
> 
> James
> 

Well I opened the server. nothing much to play with everything is tied up and 
I don't think anything except maybe disks has been changed since this server 
was bought.
Can It be related to disk jumper settings ? Anything else you can think of ?
