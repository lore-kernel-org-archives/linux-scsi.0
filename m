From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V3 1/4] Encapsulate scsi_do_report_luns
Date: Thu, 07 Mar 2013 17:48:48 +0000
Message-ID: <1362678528.9043.8.camel@dabdike.int.hansenpartnership.com>
References: <1362663515-3476-1-git-send-email-revers@redhat.com>
	 <1362663515-3476-2-git-send-email-revers@redhat.com>
	 <94D0CD8314A33A4D9D801C0FE68B402950DA726C@G9W0745.americas.hpqcorp.net>
	 <5138BB1F.9080904@tributary.com>
	 <94D0CD8314A33A4D9D801C0FE68B402950DA733C@G9W0745.americas.hpqcorp.net>
	 <1362677438.9043.6.camel@dabdike.int.hansenpartnership.com>
	 <94D0CD8314A33A4D9D801C0FE68B402950DA7385@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35070 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852Ab3CGRsx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Mar 2013 12:48:53 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402950DA7385@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Jeremy Linton <jlinton@tributary.com>, Rob Evers <revers@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "bvanassche@acm.org" <bvanassche@acm.org>, "emilne@redhat.com" <emilne@redhat.com>

On Thu, 2013-03-07 at 17:38 +0000, Elliott, Robert (Server Storage)
wrote:
> So far the T10 Base feature set proposal has not been restating
> requirements already required by the core standards - it's just
> upgrading "mays" and "shoulds" to "shalls".  Should we also include a
> list of "shall" rules like this that have had known violations in the
> past?

You mean trying to catalogue known broken behaviour?  That's a pretty
monumental task, particularly when you have to deal with all the USB
SCSI implementations, which is where a lot of our current violations
come from.

James


