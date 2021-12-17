Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A91FBC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Dec 2021 04:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhLQEEa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Dec 2021 23:04:30 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13088 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229617AbhLQEEa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Dec 2021 23:04:30 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BH2b1L8013696;
        Fri, 17 Dec 2021 04:04:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=h1Gz3NmkkvAQalHSEv+c/ZfxMQ6PAkxx2LFttZmQzBU=;
 b=mir5ta//8ikpWmg1jPS4rWiWb4oI6UZNmHNrlgiGOaRLqUzgu3NJE8L66RKPNK2zkvtu
 tCYSRW4M9genKAT3aw29Xg2WBZKz6mrsgniY4fTAhD1Y+kKJdqJC3XmME4+/R56VivaH
 zVeQdqnupxR/2AJqUe/aGUsqeI2fqogxgdooNweyh/Ln5A/BtR2Wwys3AWTZSTHczixt
 EmK0JXa/LDHkPedLxsliezhAj7i4tjbSZRa+KV+ajAybfZIEtTUv6bV4aeFNdZOxcWPm
 8O8zBJzPSMJ9mGMwwS5y9xqpBxGv0HzjK5u7xGnYXmhBE2sadLW5SlMXImWSYTd/cv87 yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cyknc4pmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 04:04:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BH3xtUv028755;
        Fri, 17 Dec 2021 04:04:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3cvneuxymt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 04:04:23 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1BH44N7e044176;
        Fri, 17 Dec 2021 04:04:23 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3cvneuxyky-1;
        Fri, 17 Dec 2021 04:04:23 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Terminate string in lpfc_debugfs_nvmeio_trc_write()
Date:   Thu, 16 Dec 2021 23:04:22 -0500
Message-Id: <163971366746.31337.1114049407966426649.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211214070527.GA27934@kili>
References: <20211214070527.GA27934@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: L7mCZ3ajZ0Qh6kiWUldW5Gy_ng0p6f_X
X-Proofpoint-GUID: L7mCZ3ajZ0Qh6kiWUldW5Gy_ng0p6f_X
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 14 Dec 2021 10:05:27 +0300, Dan Carpenter wrote:

> The "mybuf" string comes from the user, so we need to ensure that it is
> NUL terminated.
> 
> 

Applied to 5.16/scsi-fixes, thanks!

[1/1] scsi: lpfc: Terminate string in lpfc_debugfs_nvmeio_trc_write()
      https://git.kernel.org/mkp/scsi/c/9020be114a47

-- 
Martin K. Petersen	Oracle Linux Engineering
