From: kurk <kurk@shiftmail.org>
Subject: Re: [Bugme-new] [Bug 11045] New: Bug in MPT Fusion 2.6.26-rc7
 unbootable
Date: Thu, 10 Jul 2008 16:24:41 +0200
Message-ID: <48761BA9.9020704@shiftmail.org>
References: <bug-11045-10286@http.bugzilla.kernel.org/>
 <200807081051.33892.bjorn.helgaas@hp.com>
 <1215537813.3214.22.camel@localhost.localdomain>
 <200807081456.53460.bjorn.helgaas@hp.com>
 <20080708144720.998a13f2.akpm@linux-foundation.org>
 <1215554255.3214.48.camel@localhost.localdomain>
 <20080709080814.GA801@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-reply-to: <20080709080814.GA801@lsil.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>, "Support, Software" <support@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>
List-Id: linux-scsi@vger.kernel.org

Hi all,
Good news! James and Sathya were correct, the bug is related to MSI: 
specifying mpt_msi_enable=0 as option for the mptbase module solves the 
problem and the system can boot as usual.

Having said this, do you still want me to try a patch, or perform some 
additional test?

Just out of curiosity: do you intend to eventually modify the kernel so 
to "support" and work around buggy hardware like the one we have (IBM 
xSeries 335), so that Linux can work out of the box even on this hardware?

Thank everybody for your help
