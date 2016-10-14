From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 16/17] lpfc: Fix fw download on SLI-4 FC adapters
Date: Fri, 14 Oct 2016 09:52:28 +0200
Message-ID: <20161014075228.xydrbwf2x2k2cssj@linux-x5ow.site>
References: <58000559.ask9jYTwRrGrLPVO%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753352AbcJNHwa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 03:52:30 -0400
Content-Disposition: inline
In-Reply-To: <58000559.ask9jYTwRrGrLPVO%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Oct 13, 2016 at 03:06:17PM -0700, James Smart wrote:
> 
> Fix fw download on SLI-4 FC adapters
> 
> Driver performs a quick validation of magic numbers in the fw
> download image. Driver needed to be updated for more recent
> magic numbers.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
> v3 mods:
>  code cleanup: parsing image header fields

Thanks,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
