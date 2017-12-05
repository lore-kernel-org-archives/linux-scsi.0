From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] fnic: Fix coccinelle warnings
Date: Mon, 04 Dec 2017 22:18:02 -0500
Message-ID: <yq1374p6exh.fsf@oracle.com>
References: <1511298946-26600-1-git-send-email-gomonovych@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43884 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdLEDSK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2017 22:18:10 -0500
In-Reply-To: <1511298946-26600-1-git-send-email-gomonovych@gmail.com> (Vasyl
        Gomonovych's message of "Tue, 21 Nov 2017 22:15:46 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasyl Gomonovych <gomonovych@gmail.com>
Cc: satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Vasyl,

> Remove the duplicate copies of this simple function and use an
> open-coded version.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
