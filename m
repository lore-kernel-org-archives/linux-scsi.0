From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [Bugme-new] [Bug 7900] New: Kernel OOPS when using tape drive
 (compiler bug?)
Date: Sat, 3 Feb 2007 13:25:21 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0702031322370.6410@kai.makisara.local>
References: <200701300139.l0U1dP09019983@fire-2.osdl.org>
 <20070129180535.85950b67.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:56131 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946455AbXBCLWm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Feb 2007 06:22:42 -0500
In-Reply-To: <20070129180535.85950b67.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, michal@logix.cz

On Mon, 29 Jan 2007, Andrew Morton wrote:

> On Mon, 29 Jan 2007 17:39:25 -0800
> bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=7900
> > 
> >            Summary: Kernel OOPS when using tape drive (compiler bug?)
> >     Kernel Version: 2.6.20-rc5
> >             Status: NEW
> >           Severity: high
> >              Owner: io_scsi@kernel-bugs.osdl.org
> >          Submitter: michal@logix.cz
> > 
> > 
> > Most recent kernel where this bug did *NOT* occur:
> > Distribution: OpenSUSE 10.2 x86
> > Hardware Environment: 
> > SCSI controller "LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual
> > Ultra320 SCSI (rev 07)", tape streamer Datastor LTO1 (don't know the exact model)
> > 
> > Software Environment: OpenSUSE 10.2 x86, mondoarchive, mondorescue
> > 
> > Problem Description:
> > Attempt to restore data from a tape drive results in the following Oops and
> > subsequent functinality loss of the strreamer. Writing to the tape, however,
> > worked fine. Or at least mondoarchive haven't complained.
> > 
I don't know how mondoarchive uses the tape. The bug 7900 looked somewhat 
similar. It might be useful to try the patch provided for that bug (in 
Bugzilla and linux-scsi).

-- 
Kai
