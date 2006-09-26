From: Tejun Heo <htejun@gmail.com>
Subject: Re: Serial ATA (sii3512a) support
Date: Tue, 26 Sep 2006 14:08:20 +0900
Message-ID: <4518B5C4.6020207@gmail.com>
References: <4515624A.4090100@skircr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.225]:31775 "EHLO
	wx-out-0506.google.com") by vger.kernel.org with ESMTP
	id S1750996AbWIZFI0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Sep 2006 01:08:26 -0400
Received: by wx-out-0506.google.com with SMTP id s14so2070501wxc
        for <linux-scsi@vger.kernel.org>; Mon, 25 Sep 2006 22:08:26 -0700 (PDT)
In-Reply-To: <4515624A.4090100@skircr.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Atkins <satkins@skircr.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>

[cc'ing linux-ide]

Stephen Atkins wrote:
> Hello everyone.  I'm just wondering what the status is for the Silicon
> Image 3512a serial ata support is.

Pretty good actually.

> I was using gentoo-sources 2.6.12 my Seagate drives worked fine.  I'm
> now running a gentoo-sources 2.6.15-r1 and support has broken.  The same
> thing with gentoo-sources 2.6.17-r8.  I've added my drives to the
> sata_sil.c black list (one of them was missing) but I still get
> "Abnormal status 0x58 on port ..." errors.  Which essentially crashes my
> machine.

That looks like transmission failure and to me it doesn't seem to be a 
driver problem and please don't add your drive to sata_sil blacklist. 
The blacklist is for very specific cases and won't fix your problem 
other than sometimes hiding the real problem by slowing things down a lot.

When does such error occur?  Is it reproducible?  How often does it occur?

> Unfortunately I don't have the 2.6.12 kernel from Gentoo any more as I
> did a emerge --sync and it got rid of it.  Also some of the other
> drivers I'm using need more recent kernel versions.
> 
> Just some notes on my MB/chipsets.  I've got a Gigabyte GA-7N400Pro2
> with an nForce2 chipset.  It has a on board SATA which the manual says
> is a Sil3112 but the bios reports it as a Sil3512a.  I've got a single 6
> gig IDE as my boot device and root dir.  There are also two SATA drives
> both are Seagates.  One is a ST3250823AS (250 gigs) and a ST3120026AS
> (120 gigs).  I know the Seagate drives have some issues and hence the
> black list.
> 
> Just wondering if there is anything I can do to make these things work
> in some of the latest kernels.  Thanks for you help.

Can you give a shot at 2.6.18?  It contains improved EH which should be 
able to recover from the condition you described.

-- 
tejun
