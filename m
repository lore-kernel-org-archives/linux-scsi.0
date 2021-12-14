Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A00FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 04:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhLNElF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Dec 2021 23:41:05 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:36470 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229520AbhLNElA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Dec 2021 23:41:00 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE2rF74005512;
        Tue, 14 Dec 2021 04:40:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=JRidcUInGoDJsTe5sP1HXfavGBkFo33gpM3LV1i54+8=;
 b=BE1Z4D5NsfH9kR1257I3vx7OU1T8G0JTMtWyOWprk6cdUUZ3QdS0dVVYmArh7sQcCVI5
 V/mfDHpUK/bDTmiJW7LTxtGSdGkm6M0egRSb11DSIBdOisS8IqpEliFdM//tk4OaLvh4
 0ud9Hav/xzCYPTTVS1Q3KSk6pjQ7sohvebP3mzlia0a5q2IGuXUicnPbxm7sHjnIpN2P
 Tw1fpJnbTTdBcdzsi7sF2wrqucvjB/P2pr7z1NTkFwnsypiyDY0a5HX4AzwfS5S/5WU7
 XfziOKX6WotD+Hfdeweg4uDK/JBXhIk+4/MXYqSn/XCn+LJc4Q2pBirfmK8nyJ18nHGE dQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx56u2asf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 04:40:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE4ZYUO032464;
        Tue, 14 Dec 2021 04:40:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3cvh3wp5ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 04:40:53 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1BE4aj96034843;
        Tue, 14 Dec 2021 04:40:53 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3cvh3wp5ab-1;
        Tue, 14 Dec 2021 04:40:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi/be2iscsi: Remove non existing maintainer.
Date:   Mon, 13 Dec 2021 23:40:47 -0500
Message-Id: <163945683292.11687.10637528981917912259.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211202201141.cytqe73ish6oa356@linutronix.de>
References: <20211202201141.cytqe73ish6oa356@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: pZB1E1ZWBceU42CVgirNEtiX_PgPriZX
X-Proofpoint-GUID: pZB1E1ZWBceU42CVgirNEtiX_PgPriZX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2 Dec 2021 21:11:41 +0100, Sebastian Andrzej Siewior wrote:

> The email address of
>    Subbu Seetharaman <subbu.seetharaman@broadcom.com>
>    Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> 
> is no longer working.
> Remove Subbu and Jitendra as maintainer.
> 
> [...]

Applied to 5.17/scsi-queue, thanks!

[1/1] scsi/be2iscsi: Remove non existing maintainer.
      https://git.kernel.org/mkp/scsi/c/4c3e3f8cfc05

-- 
Martin K. Petersen	Oracle Linux Engineering
