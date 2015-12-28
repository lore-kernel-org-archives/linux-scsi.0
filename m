From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] mvsas: add SGPIO support to Marvell 94xx
Date: Mon, 28 Dec 2015 13:47:28 -0800
Message-ID: <1451339248.2331.7.camel@HansenPartnership.com>
References: <5645BEE0.3050406@gmx.at> <yq160zrp5jc.fsf@sermon.lab.mkp.net>
	 <56803A2F.2030507@gmx.at> <1451245374.2283.2.camel@HansenPartnership.com>
	 <56804A5F.5040000@gmx.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53992 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752469AbbL1Vra (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Dec 2015 16:47:30 -0500
In-Reply-To: <56804A5F.5040000@gmx.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wilfried Weissmann <Wilfried.Weissmann@gmx.at>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

On Sun, 2015-12-27 at 21:30 +0100, Wilfried Weissmann wrote:
> Am 27.12.15 um 20:42 schrieb James Bottomley:
> > On Sun, 2015-12-27 at 20:21 +0100, Wilfried Weissmann wrote:
> > > add SGPIO support to Marvell 94xx
> > 
> > How do you actually use this?  It doesn't seem to be plumbed into
> > the
> > standard GPIO subsystem and there appears to be no user accessible
> > interface for it either (nor is it used internally).
> > 
> > There doesn't appear to be much point adding an unusable feature.
> 
> sas_domain_function_template.lldd_write_gpio exposes the interface to 
> libsas. Userspace access is then done via ioctl(SG_IO,...). Existing 
> user space tools such as ledmon use this method, also smp_utils in 
> case you want to have more direct control.

Ah, right, I'd forgotten that got added.

Reviewed-by: James Bottomley <James.Bottomley@HansenPartnership.com>

Thanks,

James


