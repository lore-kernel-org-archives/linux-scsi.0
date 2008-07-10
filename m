From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 11045] New: Bug in MPT Fusion 2.6.26-rc7
 unbootable
Date: Thu, 10 Jul 2008 16:44:24 -0700
Message-ID: <20080710164424.2a0c3622.akpm@linux-foundation.org>
References: <bug-11045-10286@http.bugzilla.kernel.org/>
	<200807081051.33892.bjorn.helgaas@hp.com>
	<1215537813.3214.22.camel@localhost.localdomain>
	<200807081456.53460.bjorn.helgaas@hp.com>
	<20080708144720.998a13f2.akpm@linux-foundation.org>
	<1215554255.3214.48.camel@localhost.localdomain>
	<20080709080814.GA801@lsil.com>
	<48762211.5040301@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526AbYGJXul (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2008 19:50:41 -0400
In-Reply-To: <48762211.5040301@shiftmail.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kurk <kurk@shiftmail.org>
Cc: "Prakash, Sathya" <sathya.prakash@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>, "Support, Software" <support@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>

On Thu, 10 Jul 2008 16:52:01 +0200 kurk <kurk@shiftmail.org> wrote:

> Prakash, Sathya wrote:
> > This may  be a problem due to enabling MSI for SPI controllers. I have posted another message in the list providing the correction patch which is already in scsi-misc tree. 
> > If the problem is gone with changing the module parameter mpt_msi_enable=0 or by applying the patch http://marc.info/?l=linux-scsi&m=121131228827682&w=4 then it might be due to MSI enabling.
> >   
> Another good news: I confirm that yes, the problem is also fixed by the 
> patch linked above by Sathya, and in that case it is not needed to 
> specify option mpt_msi_enable=0 for mptbase. Any one of the two (patch 
> or option) is enough to fix the problem.
> It would be nice to see this patch in the final release of the 2.6.26 kernel
> Thank you

James, shouldn't we put that into 2.6.26?

That whole patch series looks pretty desirable actually..
