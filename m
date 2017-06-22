From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] lpfc: Fix nvme io stoppage after link bounce
Date: Thu, 22 Jun 2017 09:41:43 +0200
Message-ID: <20170622074142.GB5670@linux-x5ow.site>
References: <20170621173758.28058-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54265 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751124AbdFVHls (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jun 2017 03:41:48 -0400
Content-Disposition: inline
In-Reply-To: <20170621173758.28058-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>

On Wed, Jun 21, 2017 at 10:37:58AM -0700, James Smart wrote:
[...]
> -	/*
> -	 * Catch race where our node has transitioned, but the
> -	 * transport is still transitioning.
> -	 */


The patch looks fine but can you please explain why the above race can't
happen anymore?

Thanks,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
