From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [2.6 patch] SCSI_AIC94XX must depend on SCSI
Date: Thu, 06 Mar 2008 16:07:42 -0600
Message-ID: <1204841262.3062.60.camel@localhost.localdomain>
References: <200803062009.20309.toralf.foerster@gmx.de>
	 <20080306202246.GB5259@cs181133002.pp.htv.fi>
	 <1204835467.3062.42.camel@localhost.localdomain>
	 <20080306213938.GA1574@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54192 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765317AbYCFWHp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 17:07:45 -0500
In-Reply-To: <20080306213938.GA1574@cs181133002.pp.htv.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2008-03-06 at 23:39 +0200, Adrian Bunk wrote:
> This is the right fix for this bug.

Incidentally, just for future reference, this:

> We have:
> - SCSI=m
> - SCSI_AIC94XX=y
> - SCSI_MVSAS=m
> - SCSI_SAS_LIBSAS=y
> 
> The problem is:
> - SCSI_AIC94XX selects (and requires) SCSI_SAS_LIBSAS
> - SCSI_MVSAS selects (and requires) SCSI_SAS_LIBSAS
> - with SCSI=m a SCSI_SAS_LIBSAS=y is not linked into the kernel
> 
> SCSI_AIC94XX=y also results in the AIC94xx driver not being linked into 
> the kernel here (and that's also fixed by this patch), but this alone 
> wouldn't result in a build bug...

Is the right changelog for your fix (even if it got superceded), rather
than a compile dump that doesn't even mention the driver you're
patching.

James


