Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C17C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 13:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343707AbiDGNhr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 09:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343687AbiDGNhf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 09:37:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBBC266C
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 06:35:31 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237AYA25012575
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=ANQKoydSoiZ7uSnt0tmmdBsPtAZ0NpP7UiFlW+MXfKg=;
 b=twxlpS+bBNStpbJdIZbuK6KhRI6vpYTeMgIk4ttkSFLh2KggcISya9bFrJmv47UkRvM9
 mWjGnJ4sEntmd2BP7V5227RdPTeggF7Df2a6RsXS37nMpOhDaJWu3ukUK+C8dWuhE0OM
 rBYbBHkBddxvCYYJgQgIILylKru7HpnVpW6hY8qUPpVdx7NzOVUJUTYEYmH7KViFCowx
 ATGM+i8fbERyjilqzwalJEMQvprXv5xBUQNxCxJqSNvoRn1W0+gBSEjxnmWN09JJ59hK
 WAWCoL/kGyLSa9c3dzEQMSK7lY66WqyAo4KZnb/dzu8/UV9I9X1TnNUgxfQREioBJanf pg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwckm03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:30 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLVBD036848
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:29 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 237DZJM8032479
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:29 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvpy-14;
        Thu, 07 Apr 2022 13:35:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: core: sysfs: remove comments that conflict with the actual logic
Date:   Thu,  7 Apr 2022 09:35:13 -0400
Message-Id: <164929679001.15424.17988937858421269423.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220329021251.123805-1-liu.yun@linux.dev>
References: <20220329021251.123805-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: ZtX21EkS0ATB5R2_hmABJjotnDYM5CjR
X-Proofpoint-GUID: ZtX21EkS0ATB5R2_hmABJjotnDYM5CjR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 29 Mar 2022 10:12:51 +0800, Jackie Liu wrote:

> From: Jackie Liu <liuyun01@kylinos.cn>
> 
> Christoph Hellwig Says:
> =======================
> I think we should just handle the error properly and remove the comment.
> There's no good reason to ignore bsg registration errors.
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[1/1] scsi: core: sysfs: remove comments that conflict with the actual logic
      https://git.kernel.org/mkp/scsi/c/99241e119f4a

-- 
Martin K. Petersen	Oracle Linux Engineering
