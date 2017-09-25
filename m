From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: csiostor: enable PCIe relax ordering if supported
Date: Mon, 25 Sep 2017 15:34:16 -0400
Message-ID: <yq11smuh8sn.fsf@oracle.com>
References: <1504021726-12777-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35045 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965909AbdIYTeV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 15:34:21 -0400
In-Reply-To: <1504021726-12777-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Tue, 29 Aug 2017 21:18:46 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, indranil@chelsio.com, rajesh.kumar@chelsio.com


Varun,

> Set PCIe relax ordering bits in FW_IQ_CMD if relax ordering is enabled
> in the PCIe device.

Applied to 4.15/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
