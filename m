From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] aha152x-2.6.1
Date: Tue, 20 Jan 2004 20:44:33 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0401202021050.7148-100000@poirot.grange>
References: <1074538162.1647.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:11952 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265700AbUATTsY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 14:48:24 -0500
In-Reply-To: <1074538162.1647.18.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On 19 Jan 2004, James Bottomley wrote:

> On Sat, 2004-01-17 at 17:25, Guennadi Liakhovetski wrote:
> > Below is a patch for aha152x to fix check / request_region, plus make it
> > fail explicitly in the case of busy address-range. Compiles, untested
> > (yet).
>
> Actually, the aha152x maintainer has already fixed this (and the fix is
> in mainline---and copying the maintainer on changes to his driver would
> have been polite).

Really sorry - sure must have done that. The only slight excuse is, that I
just saw a request from a user, tried to help, and, eventually, came up
with a patch. But - no problem, if there's a patch from the maintainer
(he's written to me too telling about this), sure it has precedence. I had
some fun anyway and learned a bit more about one more driver.

> > While on that - what about the advansys-patch with a similar (check_region
> > vs. request_region) scope, I sent earlier to the list - was it wrong, or
> > just not important enough?
>
> Erm, this is what you said about the Advansys patch:
>
> "Ok, the attached patch (carefully, I hope) does request_region instead of
> check_region for the detection address-range, and then release_region -
> when needed. Hope I got it right. Compiles, otherwise completely untested."
>
> which wasn't exactly a ringing endorsement.  If we don't get any
> comments or complaints, I'll probably add it to the SCSI patch list.

:-) Ok, I'll try to ring louder next time:-) I am quite new to SCSI, so,
if I do happen to send a patch, a short comment, like "it's crap because
that and that", or "it's crap, but it has a chance if you fix that and
that", or "accepted" would be great!:-)

Thanks
Guennadi
---
Guennadi Liakhovetski


