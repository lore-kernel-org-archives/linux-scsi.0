From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] aha152x-2.6.1
Date: 19 Jan 2004 19:46:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074538162.1647.18.camel@mulgrave>
References: <Pine.LNX.4.44.0401172318380.963-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:26251 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265340AbUATAqn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 19:46:43 -0500
In-Reply-To: <Pine.LNX.4.44.0401172318380.963-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-01-17 at 17:25, Guennadi Liakhovetski wrote:
> Below is a patch for aha152x to fix check / request_region, plus make it
> fail explicitly in the case of busy address-range. Compiles, untested
> (yet).

Actually, the aha152x maintainer has already fixed this (and the fix is
in mainline---and copying the maintainer on changes to his driver would
have been polite).

> While on that - what about the advansys-patch with a similar (check_region
> vs. request_region) scope, I sent earlier to the list - was it wrong, or
> just not important enough?

Erm, this is what you said about the Advansys patch:

"Ok, the attached patch (carefully, I hope) does request_region instead of
check_region for the detection address-range, and then release_region -
when needed. Hope I got it right. Compiles, otherwise completely untested."

which wasn't exactly a ringing endorsement.  If we don't get any
comments or complaints, I'll probably add it to the SCSI patch list.

James


