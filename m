From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH V3 1/4] Encapsulate scsi_do_report_luns
Date: Thu, 7 Mar 2013 17:38:14 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402950DA7385@G9W0745.americas.hpqcorp.net>
References: <1362663515-3476-1-git-send-email-revers@redhat.com>
	 <1362663515-3476-2-git-send-email-revers@redhat.com>
	 <94D0CD8314A33A4D9D801C0FE68B402950DA726C@G9W0745.americas.hpqcorp.net>
	 <5138BB1F.9080904@tributary.com>
	 <94D0CD8314A33A4D9D801C0FE68B402950DA733C@G9W0745.americas.hpqcorp.net>
 <1362677438.9043.6.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:23592 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3CGRj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Mar 2013 12:39:27 -0500
In-Reply-To: <1362677438.9043.6.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeremy Linton <jlinton@tributary.com>, Rob Evers <revers@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "bvanassche@acm.org" <bvanassche@acm.org>, "emilne@redhat.com" <emilne@redhat.com>

So far the T10 Base feature set proposal has not been restating requirements already required by the core standards - it's just upgrading "mays" and "shoulds" to "shalls".  Should we also include a list of "shall" rules like this that have had known violations in the past?


> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Thursday, 07 March, 2013 11:31 AM
> To: Elliott, Robert (Server Storage)
> Cc: Jeremy Linton; Rob Evers; linux-scsi@vger.kernel.org;
> michaelc@cs.wisc.edu; bvanassche@acm.org; emilne@redhat.com
> Subject: Re: [PATCH V3 1/4] Encapsulate scsi_do_report_luns
> 
> On Thu, 2013-03-07 at 17:01 +0000, Elliott, Robert (Server Storage)
> wrote:
> > Good point; INQUIRY, REPORT LUNS, REQUEST SENSE, and NOTIFY DATA
> > TRANSFER DEVICE do not report unit attention conditions.
> 
> Well, yes they do, at least on several devices I have here.
> 
> Can I point out again that we can't code to SAM ... we have to code to
> what already exists. SAM is useful as a guideline, but it isn't gospel.
> In particular where the real world does something SAM says it shouldn't
> (like sending UA to INQUIRY), we have to go with the real world.
> 
> This also means we can't go through the linux SCSI subsystem changing
> behaviour based on what SAM says the behaviour should be.  Most of what
> the SCSI subsystem does is an accumulation based on years of trying to
> fix it for annoying and out of spec devices.
> 
> James
> 

