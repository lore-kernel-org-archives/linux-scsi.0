From: Karsten Wiese <annabellesgarden@yahoo.de>
Subject: Re: Help needed: No CD-Recording on 2.6.9 / 2.6.10 for TEAC CD-R55S @ sym53c8xx
Date: Wed, 15 Dec 2004 01:05:54 +0100
Message-ID: <200412150105.54482.annabellesgarden@yahoo.de>
References: <200412141738.01763.annabellesgarden@yahoo.de> <m3ekhsfvoq.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp001.mail.ukl.yahoo.com ([217.12.11.32]:14194 "HELO
	smtp001.mail.ukl.yahoo.com") by vger.kernel.org with SMTP
	id S261730AbULOAFn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Dec 2004 19:05:43 -0500
In-Reply-To: <m3ekhsfvoq.fsf@merlin.emma.line.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx

Am Dienstag 14 Dezember 2004 21:53 schrieb Matthias Andree:
> Karsten Wiese <annabellesgarden@yahoo.de> writes:
> 
> > IIRC stuff also ill behaved with 2.4 kernel and sym53c8xx_2 module.
> > 2.4 kernel with ncr53c8xx module lets cdrecord work just fine. (Just
> > verified with knoppix 3.4 boot cd.)
> 
> Are you using cdrecord setuid? If so, remove the setuid bit and retry
> with "sudo".
> 
I ran those tests as root. So the setuid bit should be irrelevant, no?
And it is not set anyhow, just checked.
Me still thinks, this failure is related to the sym53c8xx module not working correctly with the scsi card.
Should I try to port 2.4's ncr53c8xx to 2.6 ? hrm.... =:)

Karsten
