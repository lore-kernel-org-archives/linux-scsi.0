From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bnx2fc: Simplify code
Date: Fri, 09 Sep 2016 07:06:51 -0400
Message-ID: <yq1h99pgwms.fsf@sermon.lab.mkp.net>
References: <1472886348-29813-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33072 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753460AbcIILHD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2016 07:07:03 -0400
In-Reply-To: <1472886348-29813-1-git-send-email-christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Sat, 3 Sep 2016 09:05:48 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: QLogic-Storage-Upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

>>>>> "Christophe" == Christophe JAILLET <christophe.jaillet@wanadoo.fr> writes:

Christophe> Calling 'list_splice' followed by 'INIT_LIST_HEAD' is
Christophe> equivalent to 'list_splice_init'.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
