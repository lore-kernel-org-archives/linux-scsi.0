From: "Kolli, Neela" <Neela.Kolli@lsil.com>
Subject: RE: Problem with legacy megaraid
Date: Wed, 4 Oct 2006 07:01:55 -0600
Message-ID: <9738BCBE884FDB42801FAD8A7769C265F8A982@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42157 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932409AbWJDNCB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Oct 2006 09:02:01 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Lee <labmonkey42@gmail.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, "Ju, Seokmann" <Seokmann.Ju@engenio.com>, linux-scsi@vger.kernel.org

Hi Chris,
This being a "Dell controller", Dell customer service would be the
starting point to handle this.

Thanks,
Neela Syam Kolli.


-----Original Message-----
From: Chris Lee [mailto:labmonkey42@gmail.com] 
Sent: Wednesday, October 04, 2006 6:22 AM
To: linux-kernel@vger.kernel.org
Cc: 'Andrew Morton'; Ju, Seokmann; linux-scsi@vger.kernel.org; Kolli,
Neela
Subject: RE: Problem with legacy megaraid

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

To update... I've rolled back to 2.6.{12,11,9} and can still reproduce
the
problem on all of them.  I'm out of ideas as to where I can look for the
cause.  If anyone (LSI, Dell people maybe?) has any ideas please let me
know.

Thanks,
Chris  

