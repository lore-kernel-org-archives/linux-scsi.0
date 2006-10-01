From: "Chris Lee" <labmonkey42@gmail.com>
Subject: RE: Problem with legacy megaraid
Date: Sun, 1 Oct 2006 01:44:04 -0500
Message-ID: <451f63b0.0b6e62c3.1073.0ffa@mx.gmail.com>
References: <20060930230259.497b7bc9.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.228]:20420 "EHLO
	wx-out-0506.google.com") by vger.kernel.org with ESMTP
	id S1752036AbWJAGoA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Oct 2006 02:44:00 -0400
Received: by wx-out-0506.google.com with SMTP id s14so1379220wxc
        for <linux-scsi@vger.kernel.org>; Sat, 30 Sep 2006 23:44:00 -0700 (PDT)
In-Reply-To: <20060930230259.497b7bc9.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Andrew Morton' <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, "'Ju, Seokmann'" <Seokmann.Ju@lsil.com>, linux-scsi@vger.kernel.org, Neela.Kolli@engenio.com

> > > 
> > > > Distro: Gentoo Linux
> > > > Kernel: 2.6.17-gentoo-r7
> > > > 
> > > > Hardware:
> > > > Motherboard: Tyan Thunder i7501 Pro (S2721-533)
> > > > CPUs: Dual 2.8Ghz P4 HT Xeons
> > > > RAM: 4GB registered (3/1 split, flat model)
> > > > RAID: Dell PERC2/DC (AMI Megaraid 467)
> > > > SCSI: Adaptec AHA-2940U2/U2W PCI
> > > > NICs: onboard e100 and dual onboard e1000
> > > > 
> 
> Did it work correctly under any earlier kernel version?  If 
> so, which?

I've recently built the system and the problem was present with both
2.6.16-gentoo-r4 and now 2.6.17-gentoo-r7.  I've not used any earlier kernel
versions in this system.

Thanks,
Chris  

