From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: csiostor: fail probe if fw does not support FCoE
Date: Mon, 07 Aug 2017 21:58:37 -0400
Message-ID: <yq1inhy95wy.fsf@oracle.com>
References: <1501518775-8889-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47878 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbdHHB6n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2017 21:58:43 -0400
In-Reply-To: <1501518775-8889-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Mon, 31 Jul 2017 22:02:55 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, indranil@chelsio.com, rajesh.kumar@chelsio.com


Varun,

> Fail probe if FCoE capability is not enabled in the firmware.

Applied to 4.13/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
