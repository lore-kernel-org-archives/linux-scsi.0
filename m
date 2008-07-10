From: kurk <kurk@shiftmail.org>
Subject: Re: [Bugme-new] [Bug 11045] New: Bug in MPT Fusion 2.6.26-rc7
 unbootable
Date: Thu, 10 Jul 2008 16:52:01 +0200
Message-ID: <48762211.5040301@shiftmail.org>
References: <bug-11045-10286@http.bugzilla.kernel.org/>
 <200807081051.33892.bjorn.helgaas@hp.com>
 <1215537813.3214.22.camel@localhost.localdomain>
 <200807081456.53460.bjorn.helgaas@hp.com>
 <20080708144720.998a13f2.akpm@linux-foundation.org>
 <1215554255.3214.48.camel@localhost.localdomain>
 <20080709080814.GA801@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-reply-to: <20080709080814.GA801@lsil.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>, "Support, Software" <support@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>
List-Id: linux-scsi@vger.kernel.org

Prakash, Sathya wrote:
> This may  be a problem due to enabling MSI for SPI controllers. I have posted another message in the list providing the correction patch which is already in scsi-misc tree. 
> If the problem is gone with changing the module parameter mpt_msi_enable=0 or by applying the patch http://marc.info/?l=linux-scsi&m=121131228827682&w=4 then it might be due to MSI enabling.
>   
Another good news: I confirm that yes, the problem is also fixed by the 
patch linked above by Sathya, and in that case it is not needed to 
specify option mpt_msi_enable=0 for mptbase. Any one of the two (patch 
or option) is enough to fix the problem.
It would be nice to see this patch in the final release of the 2.6.26 kernel
Thank you
