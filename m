From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [bug report] scsi: lpfc: Reinstate lpfc_soft_wwn parameter
Date: Tue, 17 Jan 2017 14:09:00 -0500
Message-ID: <yq1wpdtmrlf.fsf@oracle.com>
References: <20170112210804.GA19275@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24817 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbdAQTJM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 14:09:12 -0500
In-Reply-To: <20170112210804.GA19275@mwanda> (Dan Carpenter's message of "Fri,
        13 Jan 2017 00:08:04 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: jsmart2021@gmail.com, linux-scsi@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> The patch 352e5fd10598: "scsi: lpfc: Reinstate lpfc_soft_wwn
Dan> parameter" from Dec 30, 2016, leads to the following static checker
Dan> warning:

Dan> 	drivers/scsi/lpfc/lpfc_attr.c:2156 lpfc_soft_wwpn_store() info:
Dan> return a literal instead of 'rc'

James?

-- 
Martin K. Petersen	Oracle Linux Engineering
