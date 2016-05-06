From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Subject: RE: [PATCH resend v2] [SCSI] bfa: fix bfa_fcb_itnim_alloc() error
 handling
Date: Fri, 6 May 2016 06:44:01 +0000
Message-ID: <CY1PR11MB0218498E60CACA99E39CA608947D0@CY1PR11MB0218.namprd11.prod.outlook.com>
References: <20160413111441.GC4247@mwanda>
 <yq1inysvv12.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0131.outbound.protection.outlook.com ([207.46.100.131]:43973
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751171AbcEFHQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2016 03:16:32 -0400
In-Reply-To: <yq1inysvv12.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

Apologies for the delay. Patch looks good.

Acked by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>


-----Original Message-----
From: Martin K. Petersen [mailto:martin.petersen@oracle.com] 
Sent: 06 May 2016 06:54
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>; Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>; James E.J. Bottomley <jejb@linux.vnet.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>; linux-scsi <linux-scsi@vger.kernel.org>; kernel-janitors@vger.kernel.org
Subject: Re: [PATCH resend v2] [SCSI] bfa: fix bfa_fcb_itnim_alloc() error handling

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> The caller assumes that "itnim" is NULL on error and non-NULL on 
Dan> success but really "itnim" is uninitialized on error.  This 
Dan> function should just use normal error handling where it returns 
Dan> zero on success and negative on failure.

Anil, please review:

	https://patchwork.kernel.org/patch/8820751/

-- 
Martin K. Petersen	Oracle Linux Engineering
