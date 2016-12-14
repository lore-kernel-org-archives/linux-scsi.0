From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: cxgb4i,libcxgbi: add missing module_put()
Date: Wed, 14 Dec 2016 15:12:19 -0500
Message-ID: <yq18triclss.fsf@sermon.lab.mkp.net>
References: <1481125005-17177-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44741 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933105AbcLNUM2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2016 15:12:28 -0500
In-Reply-To: <1481125005-17177-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Wed, 7 Dec 2016 21:06:45 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, indranil@chelsio.com

>>>>> "Varun" == Varun Prakash <varun@chelsio.com> writes:

Varun> Add module_put() in cxgbi_sock_act_open_req_arp_failure() to
Varun> release module reference in case of arp failure, also check
Varun> return value of try_module_get() before posting active open hw
Varun> cmd.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
