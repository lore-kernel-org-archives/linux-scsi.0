From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] signed bug in scsi_device.h
Date: Thu, 13 May 2004 18:10:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040513181047.A13153@infradead.org>
References: <20040513164306.GA27050@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:35078 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264316AbUEMRKs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 13:10:48 -0400
Content-Disposition: inline
In-Reply-To: <20040513164306.GA27050@suse.de>; from olh@suse.de on Thu, May 13, 2004 at 06:43:06PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org

On Thu, May 13, 2004 at 06:43:06PM +0200, Olaf Hering wrote:
> 
> one of the recent aic7xxx versions puts a -1 in scsi_cmnd->device->type,
> in drivers/scsi/aic7xxx/aic79xx_osm.c
> that doesnt work very well on ppc because aic7xxx tends to use -Werror.
> 
> maybe scsi_level needs the signed as well.

Maybe aic7xxx should stop doing stuff like that instead?

