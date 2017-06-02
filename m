From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: cxgb4i,libcxgbi: in error case RST tcp conn
Date: Fri, 02 Jun 2017 15:00:15 -0400
Message-ID: <yq1vaoejjuo.fsf@oracle.com>
References: <1495896771-21910-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45819 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbdFBTAU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 15:00:20 -0400
In-Reply-To: <1495896771-21910-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Sat, 27 May 2017 20:22:51 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, indranil@chelsio.com


Varun,

> If logout response is not received and ->ep_disconnect() is called
> then close tcp conn by RST instead of FIN to cleanup conn resources
> immediately.
>
> Also move ->csk_push_tx_frames() above 'done:' to avoid calling
> ->csk_push_tx_frames() in error cases.

Applied to 4.12/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
