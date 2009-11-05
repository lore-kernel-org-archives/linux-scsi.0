From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] zfcp: Test kmalloc failure in scsi_get_vpd_page()
Date: Thu, 05 Nov 2009 13:41:33 -0600
Message-ID: <1257450093.10355.28.camel@mulgrave.site>
References: <4A92BE18.50208@gmail.com>
	 <1251416731.27356.8.camel@mulgrave.site>  <4A9A6676.8050304@panasas.com>
	 <1251642902.10135.4.camel@mulgrave.site>
	 <1257273187.9427.22.camel@mulgrave.site>  <4AF14147.4050102@panasas.com>
	 <1257347360.2697.20.camel@mulgrave.site>  <4AF1A941.3080808@panasas.com>
	 <1257357013.10416.8.camel@mulgrave.site>  <4AF28CCF.8020605@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47327 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758273AbZKETlf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Nov 2009 14:41:35 -0500
In-Reply-To: <4AF28CCF.8020605@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Roel Kluin <roel.kluin@gmail.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Thu, 2009-11-05 at 10:29 +0200, Boaz Harrosh wrote:
> On 11/04/2009 07:50 PM, James Bottomley wrote:
> > On Wed, 2009-11-04 at 18:18 +0200, Boaz Harrosh wrote:
> > 
> > The point of checking is not to send a VPD inquiry to USB devices that
> > don't support it.  These have a very limited range of supported VPD
> > pages.
> > 
> 
> OK thanks. But maybe just define a MIN_INQUIRY_SIZE instead of hard
> coded 32 everywhere, and use that. So in future if such a device is
> found we can easily change it.

So the minimum inquiry size would actually be 36 ... from
scsi_scan.c ... and that's hard coded to a value too.

> (Never say never ;-))

I'm hoping that by the time USB devices get complex enough to need more
than 28 VPD pages, they've actually discovered what conforming to the
standards means.

James


