From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: correct sg_seg_cnt attribute min vs default
Date: Wed, 20 Dec 2017 21:28:01 -0500
Message-ID: <yq1bmishl1q.fsf@oracle.com>
References: <20171219185750.24348-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46476 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755868AbdLUC2H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Dec 2017 21:28:07 -0500
In-Reply-To: <20171219185750.24348-1-jsmart2021@gmail.com> (James Smart's
        message of "Tue, 19 Dec 2017 10:57:50 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>


James,

> Prior patch mixed up what argument in the macro was what, so min
> value was placed as the "default" argument, and the default value
> was placed as the "min" argument. Thus, when the default was applied,
> it looked like the default was smaller than the allowed min.
>
> swap argument postions to correct.

Applied to 4.16/scsi-queue (after fixing whitespace error). Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
