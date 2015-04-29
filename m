From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z:
 dev error handler -> general protection fault, RIP:
 mvs_task_prep_ata+0x80/0x3a0
Date: Wed, 29 Apr 2015 11:10:08 -0700
Message-ID: <1430331008.2189.18.camel@HansenPartnership.com>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
	 <bug-81861-11613-zXvwHJt3aC@https.bugzilla.kernel.org/>
	 <1430317204.2189.2.camel@HansenPartnership.com>
	 <CAC2CY-2YAy8GfjCHO+PrFWAuBnhfnMvK33KJ3YCVRZXJMEHykQ@mail.gmail.com>
	 <1430322102.2189.14.camel@HansenPartnership.com>
	 <CAH_2GhcOwjQqD0VYqMiD9UGRsYf4L-XRPaMHwPiRR1c2-PSQ7A@mail.gmail.com>
	 <1430330700.2189.17.camel@HansenPartnership.com>
	 <CAH_2GheihL3WE75FrDigEdPzKRK6Up=rvoU10Y2rDMfp0_2q=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37489 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861AbbD2SKK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2015 14:10:10 -0400
In-Reply-To: <CAH_2GheihL3WE75FrDigEdPzKRK6Up=rvoU10Y2rDMfp0_2q=g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Talbot <ajtalbot1@gmail.com>
Cc: Nathan Rennie-Waldock <nathan.renniewaldock@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2015-04-29 at 11:07 -0700, Adam Talbot wrote:
> My system was oopsing, pre patch.  I am happy to give you the full
> configuration. Would that help?

Not really ... the other guy on the thread has a system oopsing post
patch.  It's oopsing in a different place from yours.  That's the system
I need the configuration for.

James


