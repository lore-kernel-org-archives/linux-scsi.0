From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: cxgb4i: assign rxqs in round robin mode
Date: Mon, 26 Jun 2017 13:29:15 -0400
Message-ID: <yq1inji64k4.fsf@oracle.com>
References: <1498126669-5654-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45746 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdFZR3Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 13:29:25 -0400
In-Reply-To: <1498126669-5654-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Thu, 22 Jun 2017 15:47:49 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, indranil@chelsio.com


Varun,

> Assign rxq to TCP connections in round robin mode to use all available
> rxqs.

Applied to 4.13/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
