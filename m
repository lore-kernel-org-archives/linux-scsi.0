From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: max GiB written per boot
Date: 09 Oct 2003 15:59:21 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065736761.2288.33.camel@patehci2>
References: <1064271322.4797.9.camel@patehci2>
	 <1064847281.24854.2.camel@patehci2> <1064850600.25057.7.camel@patehci2>
	 <20030929164654.GS15415@suse.de> <1064855570.3184.3.camel@patehci2>
	 <1064865746.4262.63.camel@patehci2> <1065460336.10804.1.camel@patehci2>
	 <1065474044.6835.44.camel@patehci2> <1065484077.2899.1.camel@patehci2>
	 <20031007055714.GO972@suse.de>  <20031007151225.0a65dcb7.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:21994 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262610AbTJIV7g
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Oct 2003 17:59:36 -0400
In-Reply-To: <20031007151225.0a65dcb7.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: rddunlap@osdl.org
Cc: axboe@suse.de, linux-scsi@vger.kernel.org

> > > Having hdc=ide-scsi matter I think is a clue.
> > > 
> > > I don't yet know if this apparent correlation will hold up or not.
> >
> > Yeah, ide-scsi is broken so you probably shouldn't be using it.
>
> From:  Randy.Dunlap <rddunlap@osdl.org>
> Is there any sense in trying to repair it?
> I could spend some time on it...

Perhaps I may say: yes please!

As an ignorant newbie, myself I'd vote we at least apply the patch:

--- ./post-halloween-2.5.txt	2003-10-09 15:50:29.565344120 -0600
+++ post-halloween.txt	2003-10-09 15:52:28.323290168 -0600
@@ -571,6 +571,8 @@
 - Jens Axboe added the ability to use DMA for writing CDs on
   ATAPI devices. Writing CDs should be much faster than it
   was in 2.4, and also less prone to buffer underruns and the like.
+- Take care to remove ide-scsi.  Booting with hdc=ide-scsi or
+  modprobe'ing ide-scsi may disrupt your kernel.
 - With a recent cdrecord, you also no longer need ide-scsi in order to use
   an IDE CD writer.
 - Ripping audio tracks off of CDs now also uses DMA and should be

If that's not reality, I need more education.

If that is reality, but not what we want to say, then we can balance the
work involved in updating ide-scsi vs. the likely pain of answering all
the later newbies who come here saying I swapped 2.6 into my Red Hat/
etc. 2.4/ 2.5 and life went downhill from there.

Myself I gathered 2.6 experience without ide-scsi only by luck.  I have
a usb drive and an atapi drive, I had to choose one or the other to
begin with, I happened to choose the usb drive, and I happened to
dislike the idea of overriding a kernel default.

I'm no longer sure I remember exactly how I fell back into trying
hdc=ide-scsi.  I know I'm contact with other newbies who take more the
attitude of learning to change as little as possible in how Red Hat
boots, rather than the attitude of learning how to survive with as
little from Red Hat as practical.

Pat LaVarre



