From: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] PCI legacy I/O port free driver - Making MegaRAID SAS
	driver
Date: Tue, 1 Dec 2009 23:41:08 -0800
Message-ID: <86802c440912012341q278a1169m242db29a9d5242e0@mail.gmail.com>
References: <4B0644D8.8010000@np.css.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f188.google.com ([209.85.216.188]:50053 "EHLO
	mail-px0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZLBHlC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2009 02:41:02 -0500
Received: by pxi26 with SMTP id 26so4559462pxi.21
        for <linux-scsi@vger.kernel.org>; Tue, 01 Dec 2009 23:41:09 -0800 (PST)
In-Reply-To: <4B0644D8.8010000@np.css.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Noriyuki Fujii <n-fujii@np.css.fujitsu.com>, James Bottomley <James.Bottomley@steeleye.com>
Cc: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de

2009/11/19 Noriyuki Fujii <n-fujii@np.css.fujitsu.com>:
> Hi,
>
> On the large servers, I/O port resource may not be assigned to all
> the PCI devices since it is limited (to 64KB on Intel Architecture[1])
> and it may also be fragmented (I/O base register of PCI-to-PCI bridge
> will usually be aligned to a 4KB boundary[2]).
> If no I/O port resource is assigned to devices, those devices do not
> work.
> [1] Some machines support 64KB I/O port space per PCI segment.
> [2] Some P2P bridges support optional 1KB aligned I/O base.
>
> Therefore, I made a patch for MegaRAID SAS driver to make PCI legacy I/O
> port free.
> I have also tested the patch and it had no problem.
>
> The way to make PCI legacy I/O port free is the same as Fusion-MPT
> driver's and it has been merged into 2.6.30.4.
>
> This has already been fixed in e1000 and lpfc.
>
> As a result of the above, the driver can handle its device even when
> there are a huge number of PCI devices being used on the system and no
> I/O port region assigned to the device.
>
> Thanks,
> Noriyuki Fujii
>
> Signed-off-by: Noriyuki Fujii n-fujii@np.css.fujitsu.com

Tested-by: Yinghai Lu <yinghai@kernel.org>

YH
