From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Summary of the Multi-Path BOF at OLS and future directions
Date: Fri, 8 Aug 2003 13:15:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030808131543.A5698@infradead.org>
References: <64655AAA92E6ED46B9AC9421260D96A5025BD653@srmanning.lss.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:51716 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S271116AbTHHMPq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2003 08:15:46 -0400
Content-Disposition: inline
In-Reply-To: <64655AAA92E6ED46B9AC9421260D96A5025BD653@srmanning.lss.emc.com>; from jansen_frank@emc.com on Fri, Aug 08, 2003 at 08:13:11AM -0400
List-Id: linux-scsi@vger.kernel.org
To: "jansen, frank" <jansen_frank@emc.com>
Cc: =?iso-8859-1?Q?'Josef_M=F6llers'?= <josef.moellers@fujitsu-siemens.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Aug 08, 2003 at 08:13:11AM -0400, jansen, frank wrote:
> The delineation between the EMC boxes that require vs. not require
> a "TRESPASS" command lies not with their age, but rather their family.
> The CLARiiON family of Storage Arrays require a "TRESPASS" command to
> move a LUN from one redundant Storage Processor (SP) to another.  On the
> other hand, Symmetrix Storage Arrays do not use any such behavior.  In
> a nutshell, the Symmetrix is active on all paths, on which the LUN is
> presented, whereas the CLARiiON is active on one SP and passive on the
> other SP.

So it's rather DG arrays vs EMC ones, ok.

