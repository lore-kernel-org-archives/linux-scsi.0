From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 15/17] lpfc: Synchronize link speed with boot driver
Date: Fri, 14 Oct 2016 09:51:36 +0200
Message-ID: <20161014075136.wiftedrdi6ho22r5@linux-x5ow.site>
References: <58000558.oQvh2S/jqBX/2X/s%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37542 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753352AbcJNHvj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 03:51:39 -0400
Content-Disposition: inline
In-Reply-To: <58000558.oQvh2S/jqBX/2X/s%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Oct 13, 2016 at 03:06:16PM -0700, James Smart wrote:
> 
> Synchronize link speed with boot driver
> 
> Link speed settings set by the boot driver are reported by the hw.
> Driver will attempt to read them, and if set, will respect their
> values.
> The driver can override the settings with its own if instructed by
> user space (via bsg), with the new values being picked up by the
> boot driver.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
> v3 mods:
>  parens cleanup
>  use shost_priv() on new code
> 

Thanks,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
