From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] some sd.c code consolidation
Date: Thu, 12 Jun 2003 07:53:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030612055303.GA12717@lst.de>
References: <20030609162402.GA1890@lst.de> <1055376373.3806.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:44217 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264738AbTFLFjb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jun 2003 01:39:31 -0400
Content-Disposition: inline
In-Reply-To: <1055376373.3806.6.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Jun 11, 2003 at 07:06:12PM -0500, James Bottomley wrote:
> On Mon, 2003-06-09 at 11:24, Christoph Hellwig wrote:
> > fold sd_init_onedisk into sd_revalidate_disk and sd_synchronize_cache
> > into sd_shutdown.
> 
> You didn't actually boot this one, did you?  There's a use before
> initialise of gendisk->private_data in sd_revalidate_disk().

You're right.  This patch is from before the upper driver LDM-ification
and I submitted it after just fixing the rejects.  Silly me.

