From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: writable mmc profiles actually are writable
Date: 06 Oct 2003 14:10:47 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065471047.5185.48.camel@patehci2>
References: <1064271322.4797.9.camel@patehci2>
	 <1064847281.24854.2.camel@patehci2> <1064850600.25057.7.camel@patehci2>
	 <20030929164654.GS15415@suse.de> <1064855570.3184.3.camel@patehci2>
	 <1064865746.4262.63.camel@patehci2> <1065460336.10804.1.camel@patehci2>
	 <1065463946.5185.8.camel@patehci2>  <20031006182223.GF972@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:19190 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261305AbTJFUK4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2003 16:10:56 -0400
In-Reply-To: <20031006182223.GF972@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org

> > +//   if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
> > +//           return -EROFS;
> > +//   if (!cd->device->writeable)
> > +//           return 0;
>
> ... obviously wrong

May I ask why this patch is obviously wrong?

What actually breaks?

How do we benefit from having cdrom.ko and sr_mod.ko redundantly refuse
writes?

I figure I should try mount of a cd-rom with this patch.  Maybe I get
mount -w when I wanted mount -r and then life goes downhill from there. 
Or maybe iso fs doesn't try to write.  Or ...

Pat LaVarre


