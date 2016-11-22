From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] scsi: be2iscsi: allocate enough memory in beiscsi_boot_get_sinfo()
Date: Mon, 21 Nov 2016 22:33:42 -0500
Message-ID: <yq137ik1949.fsf@sermon.lab.mkp.net>
References: <20161118115339.GD3281@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46350 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754957AbcKVDdu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2016 22:33:50 -0500
In-Reply-To: <20161118115339.GD3281@mwanda> (Dan Carpenter's message of "Fri,
        18 Nov 2016 14:53:39 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> We accidentally allocate sizeof(u32) instead of sizeof(struct
Dan> be_cmd_get_session_resp).

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
