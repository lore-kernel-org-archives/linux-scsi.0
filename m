From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: [Bugme-new] [Bug 6080] New: New Megaraid Module Problem
Date: Thu, 16 Feb 2006 07:36:20 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C26514208E@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:16364 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1161122AbWBPOgY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2006 09:36:24 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, "Kolli, Neela" <Neela.Kolli@engenio.com>
Cc: linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

Hi,
> > But I tried SUSE 10, Mandriva 2006, Fedora 2.0  (kernel 
> 2.6.*) and the
> > installation hanged on at exactly the same phase.
I've verified the 'megaraid' driver that is available on GIT kernel (2.6.16-rc2).
The driver 'megaraid.ko' is working fine on the kernel.
However, I'm working on another issue related to this driver. On SuSE SLES 10 (kernel 2.6.16-rc1-git3-7), the kernel claims that the driver has loaded, but it won't detect the controller nor scan the drives.
Both kernel (GIT kernel and SLES10) have same 'megaraid' driver.
I'll update here for any progress on it. 


> -----Original Message-----
> From: Andrew Morton [mailto:akpm@osdl.org] 
> Sent: Wednesday, February 15, 2006 5:33 PM
> To: Kolli, Neela
> Cc: linux-scsi@vger.kernel.org; 
> bugme-daemon@kernel-bugs.osdl.org; Ju, Seokmann
> Subject: Re: [Bugme-new] [Bug 6080] New: New Megaraid Module Problem
> 
> bugme-daemon@bugzilla.kernel.org wrote:
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=6080
> > 
> >            Summary: New Megaraid Module Problem
> >     Kernel Version: 2.6.*
> >             Status: NEW
> >           Severity: blocking
> >              Owner: andmike@us.ibm.com
> >          Submitter: fturkmen@gmail.com
> > 
> > 
> > Most recent kernel where this bug did not occur: 2.4.18
> > Distribution: SUSE 9.2, 10, Mandriva 2006, Fedora 2.0
> > 
> > Hardware Environment: HP LH 6000, LSILogic controllers 
> > 
> > Software Environment: Megaraid modules
> > 
> > Problem Description:
> > I have 3 HP LH 6000 machines and wanted to install Linux on them.
> > Everytime the install
> > hangs on "searching for info file" phase.
> > 
> > The following messages are given:
> >  megaraid: ABORTING-1 cmd=12 <c=0 t=0 l=0>
> >  megaraid: ABORTING-1[7d], fw owner.
> > 
> > when installing megaraid modules ("insmod /modules/megaraid.ko").
> > 
> > 
> > As I searched through the Internet, the old megaraid 
> modules (in kernel
> > 2.4) work fine with these devices. I could successfully 
> install SUSE 8.0.
> > But I tried SUSE 10, Mandriva 2006, Fedora 2.0  (kernel 
> 2.6.*) and the
> > installation hanged on at exactly the same phase.
> > 
> > 
> > 
> > Ps: Reported to the maintainer (Ju, Seokmann)
> > 
> > ------- You are receiving this mail because: -------
> > You are on the CC list for the bug, or are watching someone who is.
> 
