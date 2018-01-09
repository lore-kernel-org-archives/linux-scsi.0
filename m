From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: smartpqi: allow static build ("built-in")
Date: Mon, 08 Jan 2018 22:31:56 -0500
Message-ID: <yq1y3l7n1w3.fsf@oracle.com>
References: <a6c35114c589429c8e44fae02cb8fecd@microsemi.com>
        <20180102182409.3083-1-steffen.weber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41562 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754574AbeAIDcD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2018 22:32:03 -0500
In-Reply-To: <20180102182409.3083-1-steffen.weber@gmail.com> (Steffen Weber's
        message of "Tue, 2 Jan 2018 19:24:09 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Weber <steffen.weber@gmail.com>
Cc: don.brace@microsemi.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org


Steffen,

> If CONFIG_SCSI_SMARTPQI=y then don't build this driver as a module.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
