From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 14/14] lpfc: lpfc version change to 11.2.0.2
Date: Fri, 12 Aug 2016 11:45:20 +0200
Message-ID: <20160812094520.u2yvwqf53o7afll2@c203.arch.suse.de>
References: <57acc591.0V98JsEa57Kt7jan%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbcHLJpW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2016 05:45:22 -0400
Content-Disposition: inline
In-Reply-To: <57acc591.0V98JsEa57Kt7jan%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Aug 11, 2016 at 11:36:01AM -0700, James Smart wrote:
> 
> lpfc version change to 11.2.0.2
> 
> Note: expects to be on top of prior lpfc 11.2.0.0. rev and not on
> top of lpfc rev 11.2.0.1 which has fc-nvme mods as well. The patches in
> this set should apply to 11.2.0.1, excepting this version change.
> For now, this patch based on contents in scsi-misc branch of scsi git tree.
> 
> 11.2.0.1 has not yet been pulled into a linux-block branch (where nvme
> fabrics support is).
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
