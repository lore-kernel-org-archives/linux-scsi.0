From: kurk <kurk@shiftmail.org>
Subject: Re: [Bugme-new] [Bug 11045] New: Bug in MPT Fusion 2.6.26-rc7
	unbootable
Date: Thu, 10 Jul 2008 16:24:29 +0200
Message-ID: <48761B9D.7050700@shiftmail.org>
References: <bug-11045-10286@http.bugzilla.kernel.org/>
 <200807081051.33892.bjorn.helgaas@hp.com>
 <1215537813.3214.22.camel@localhost.localdomain>
 <200807081456.53460.bjorn.helgaas@hp.com>
 <20080708144720.998a13f2.akpm@linux-foundation.org>
 <1215554255.3214.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-reply-to: <1215554255.3214.48.camel@localhost.localdomain>
Sender: linux-acpi-owner@vger.kernel.org
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, "Support, Software" <support@lsi.com>, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, "Moore, Eric Dean" <Eric.Moore@lsi.com>, "Prakash, Sathya" <sathya.prakash@lsi.com>
List-Id: linux-scsi@vger.kernel.org

Bjorn,
you were right, the serial dump was not complete because there was the 
"quiet" option specified as kernel parameter.
I just uploaded the full (non-quiet) serial dump as attachment on the 
bugzilla web interface.
Thank you
