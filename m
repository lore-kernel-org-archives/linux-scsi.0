From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 01/13] lpfc: Rework lpfc to allow different sli4 cq
 and eq handlers
Date: Wed, 7 Feb 2018 10:01:32 +0100
Message-ID: <20180207090132.bvbiv62hintpesft@linux-x5ow.site>
References: <20180207022851.11800-1-jsmart2021@gmail.com>
 <20180207022851.11800-2-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752829AbeBGJBe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Feb 2018 04:01:34 -0500
Content-Disposition: inline
In-Reply-To: <20180207022851.11800-2-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

I first though of renameing:
lpfc_sli4_eq_clr_intr -> lpfc_sli4_t2_eq_clr_intr 
lpfc_sli4_eq_release -> lpfc_sli4_t2_eq_release 
lpfc_sli4_cq_release -> lpfc_sli4_t2_cq_release 

and then make lpfc_sli4_eq_clr_intr, etc... wrappers over the new function
pointers so and you could keep the callsites, but then you'd have to change
the callsites anyways as the function prototype will need to change.

So looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
