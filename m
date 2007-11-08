From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Add Documentation/DocBook/scsi_midlayer.tmpl and update kerneldoc comments and Makefile.
Date: Thu, 8 Nov 2007 14:19:41 -0600
Message-ID: <200711081419.41759.rob@landley.net>
References: <200710262318.01021.rob@landley.net> <20071104100252.c3e08c71.rdunlap@xenotime.net> <1194418040.3545.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:55157
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761980AbXKHUUS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Nov 2007 15:20:18 -0500
In-Reply-To: <1194418040.3545.31.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-scsi@vger.kernel.org, "Stephen M.Cameron" <steve.cameron@hp.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Wednesday 07 November 2007 00:47:20 James Bottomley wrote:
> On Sun, 2007-11-04 at 10:02 -0800, Randy Dunlap wrote:
> > My only concern with this ATM is its name (SCSI midlayer), but
> > chapter 2 is SCSI upper layer, chap 3 is SCSI midlayer, and
> > chap 4 is SCSI low-level interfaces.
> >
> > Chapters 2 & 4 are mostly stubs or todo list, which is OK, but if
> > those chapters remain in this docbook, it looks like the docbook
> > name should be changed (maybe later).
>
> How about just scsi.tmpl then?

I have no attachment to a specific name.  Call it what you like. :)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
