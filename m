From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 4/12]  qla2xxx: Update license.
Date: Wed, 19 Oct 2005 10:50:09 -0700
Message-ID: <20051019175009.GQ9087@plap.qlogic.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051013231614.27191.9897.sendpatchset@plap.qlogic.com> <1129275031.2873.3.camel@laptopd505.fenrus.org> <20051014162701.GA19098@plap.qlogic.org> <1129315644.5359.7.camel@laptopd505.fenrus.org> <20051019173707.GO9087@plap.qlogic.org> <20051019174312.GA5103@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:37054 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751104AbVJSRuK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 13:50:10 -0400
Content-Disposition: inline
In-Reply-To: <20051019174312.GA5103@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Arun Mittal <arun.mittal@qlogic.com>

On Wed, 19 Oct 2005, Christoph Hellwig wrote:

> On Wed, Oct 19, 2005 at 10:37:07AM -0700, Andrew Vasquez wrote:
> > Here's the updated license we'd like to propose.  Please note the
> > verbiage regarding the questionable relicensing of the driver codes
> > has been removed.
> 
> please don't hard-code qlogic in the license, you're not the only
> copytight holder and adding everyone gets to long.  The only license
> I'd be willing to dual-license my code under is the extremly simple
> mit-style license used by the openbsd project:
> 
>  http://www.openbsd.org/cgi-bin/cvsweb/src/share/misc/license.template?rev=1.2&content-type=text/x-cvsweb-markup
> 
> I'll also send you a list of the files that have singnificant contributions
> from me so you can add me to the copyright lines.I though that wasn't
> nessecary, but who knows what odd ideas legal departments will come up
> with next.

Sorry, but QLogic is not requesting that the driver codes be
dual-licensed.  The license explcitely states the codes are under the
GPL and the firmware blobs are under the BSD style license.

Where's the disconnect?

-- 
Andrew Vasquez
