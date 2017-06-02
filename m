From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: csiostor: add check for supported fw version
Date: Fri, 02 Jun 2017 17:37:56 -0400
Message-ID: <yq1tw3yhxzf.fsf@oracle.com>
References: <1496301513-3544-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33219 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750966AbdFBViP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 17:38:15 -0400
In-Reply-To: <1496301513-3544-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Thu, 1 Jun 2017 12:48:33 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, indranil@chelsio.com, rajesh.kumar@chelsio.com


Varun,

> T6 FCoE support is added in fw version 1.16.45.0 so return error if fw
> version < 1.16.45.0 for T6 adapters.

Applied to 4.13/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
