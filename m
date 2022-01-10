Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58617C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 22:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345155AbiAJWFB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jan 2022 17:05:01 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24564 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345143AbiAJWE4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jan 2022 17:04:56 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AJlela021735;
        Mon, 10 Jan 2022 22:04:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=gQQabLp6+mBl1RSvdIlzoe4vLiWSTWdX5a8ghYEimxU=;
 b=MGwEWJel7pkIWfJwReAFQVPO3Y+NeGXjsXG9d0TTyL0WqvJKT++vdoubzq6h0Hb6pYYX
 Xv1piNg1q6DW8KJvW4HDuJWNXz1zxroGxti7FzrO0lLwHJf8mY6q1N2tSaDAZUA5GVTi
 O+guD5uJIDmpH4uc4chaFYyY1ZR7cH4QcKnnGh/YqEx9RqP3Np/hWl3Glrws94H9ut8T
 6CnpE41ptZCyz8mI0zpwxPCwwyLhv9oHUn/idfCCeCzXRL7yKINITr0MV09qnYpr04eu
 9fO9RhrcUtX6wTuHAmQaKTRGkwLScv3Y1M0zyB2wZ0i3SeheZhlSOBjXQGYU62Wcdh5Q KA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgmk99hht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 22:04:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20ALtvjc138957;
        Mon, 10 Jan 2022 22:04:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3df2e3vqxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 22:04:54 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 20AM4iCE174082;
        Mon, 10 Jan 2022 22:04:53 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3df2e3vqp8-9;
        Mon, 10 Jan 2022 22:04:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [PATCH] mpt3sas: Update Persistent Trigger Pages from SysFs interface.
Date:   Mon, 10 Jan 2022 17:04:41 -0500
Message-Id: <164182835584.13635.6581726885981924375.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211227053055.289537-1-suganath-prabu.subramani@broadcom.com>
References: <20211227053055.289537-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: coGjLpDMbhUTRxZwLiP2u8T5y0lxBRXP
X-Proofpoint-ORIG-GUID: coGjLpDMbhUTRxZwLiP2u8T5y0lxBRXP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 27 Dec 2021 11:00:55 +0530, Suganath Prabu S wrote:

> Updates sysfs provided trigger values into the corresponding
> persistent trigger pages. otherwise sysfs updated trigger
> entries are not persistent across system reboot.
> 
> 

Applied to 5.17/scsi-queue, thanks!

[1/1] mpt3sas: Update Persistent Trigger Pages from SysFs interface.
      https://git.kernel.org/mkp/scsi/c/9211faa39a03

-- 
Martin K. Petersen	Oracle Linux Engineering
