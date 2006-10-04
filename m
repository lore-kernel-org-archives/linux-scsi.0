From: "Chris Lee" <labmonkey42@gmail.com>
Subject: RE: Problem with legacy megaraid
Date: Wed, 4 Oct 2006 05:21:55 -0500
Message-ID: <45238b42.596f8da9.6d92.ffff908d@mx.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.237]:11555 "EHLO
	wx-out-0506.google.com") by vger.kernel.org with ESMTP
	id S1030788AbWJDKV4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Oct 2006 06:21:56 -0400
Received: by wx-out-0506.google.com with SMTP id s14so126878wxc
        for <linux-scsi@vger.kernel.org>; Wed, 04 Oct 2006 03:21:55 -0700 (PDT)
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: 'Andrew Morton' <akpm@osdl.org>, "'Ju, Seokmann'" <Seokmann.Ju@lsil.com>, linux-scsi@vger.kernel.org, Neela.Kolli@engenio.com

> > > > 
> > > > > Distro: Gentoo Linux
> > > > > Kernel: 2.6.17-gentoo-r7
> > > > > 
> > > > > Hardware:
> > > > > Motherboard: Tyan Thunder i7501 Pro (S2721-533)
> > > > > CPUs: Dual 2.8Ghz P4 HT Xeons
> > > > > RAM: 4GB registered (3/1 split, flat model)
> > > > > RAID: Dell PERC2/DC (AMI Megaraid 467)
> > > > > SCSI: Adaptec AHA-2940U2/U2W PCI
> > > > > NICs: onboard e100 and dual onboard e1000
> > > > > 
> > 
> > Did it work correctly under any earlier kernel version?  If 
> > so, which?
> 
> I've recently built the system and the problem was present 
> with both 2.6.16-gentoo-r4 and now 2.6.17-gentoo-r7.  I've 
> not used any earlier kernel versions in this system.

To update... I've rolled back to 2.6.{12,11,9} and can still reproduce the
problem on all of them.  I'm out of ideas as to where I can look for the
cause.  If anyone (LSI, Dell people maybe?) has any ideas please let me
know.

Thanks,
Chris  

