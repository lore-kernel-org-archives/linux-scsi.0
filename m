From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH resend v2] [SCSI] bfa: fix bfa_fcb_itnim_alloc() error handling
Date: Thu, 05 May 2016 21:23:53 -0400
Message-ID: <yq1inysvv12.fsf@sermon.lab.mkp.net>
References: <20160413111441.GC4247@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20160413111441.GC4247@mwanda> (Dan Carpenter's message of "Wed,
	13 Apr 2016 14:14:41 +0300")
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> The caller assumes that "itnim" is NULL on error and non-NULL on
Dan> success but really "itnim" is uninitialized on error.  This
Dan> function should just use normal error handling where it returns
Dan> zero on success and negative on failure.

Anil, please review:

	https://patchwork.kernel.org/patch/8820751/

-- 
Martin K. Petersen	Oracle Linux Engineering
