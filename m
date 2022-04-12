Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6641EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 02:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbiDLCj1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Apr 2022 22:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbiDLCjY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2022 22:39:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4716A19C35
        for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2022 19:37:05 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BLYbwS028018;
        Tue, 12 Apr 2022 02:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=bDtxfqLklXFdqYam0Z91raTzV/rYCLXZ6aYGXujGel4=;
 b=LY6T+sjLFX93+EV/oX7Vygxmv8oFpb2FdwUq6xcRDOfrR47bo6mjamzjh29rSruoSIk1
 3D3cp33SFR11AojpbbCEpcfpcesU/rn8O/fDvM1A1yaLXB26YQ+c4jdmvoteqPVGTnvu
 ZErRkDMvwzpfpqHgSxN92kJt+j+dvIejaot/e5Wv4jTMlD2IM2exNKiVQXgT3HabPUN1
 sx8wb/5Cobia4kaaHAtLk8jynra7gRpElvpgvhNcQdsxF3rDPJLi6LphtjeOo3X3O9Qc
 IeJxoE/mz1xlgEHu1fyfBqN88RnAAWUjx/q+rWgf2rPLrr+MDGiridotv+/szUY+dWKd vA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb219w7ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 02:36:55 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C2VhkQ031341;
        Tue, 12 Apr 2022 02:36:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k2efw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 02:36:54 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 23C2ar92002744;
        Tue, 12 Apr 2022 02:36:53 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k2efv6-1;
        Tue, 12 Apr 2022 02:36:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Viswas.G@microchip.com, john.garry@huawei.com,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        damien.lemoal@opensource.wdc.com
Subject: Re: [PATCH v4 0/2] pm80xx updates
Date:   Mon, 11 Apr 2022 22:36:49 -0400
Message-Id: <164973085491.8307.16160996570835546942.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220411064603.668448-1-Ajish.Koshy@microchip.com>
References: <20220411064603.668448-1-Ajish.Koshy@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: M2AyM7OOkmbbfMEu9dLED763Mo-tId5l
X-Proofpoint-ORIG-GUID: M2AyM7OOkmbbfMEu9dLED763Mo-tId5l
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 11 Apr 2022 12:16:01 +0530, Ajish Koshy wrote:

> This patchset includes bugfixes for pm80xx driver
> 
> Changes from v3 to v4:
> 	- For upper interrupt vector patch
> 		- Removed unrequired comments
> 	- For upper inbound outbound patch
> 		- Added comments for msleep(500)
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[1/2] scsi: pm80xx: mask and unmask upper interrupt vectors 32-63
      https://git.kernel.org/mkp/scsi/c/294080eacf92
[2/2] scsi: pm80xx: enable upper inbound, outbound queues
      https://git.kernel.org/mkp/scsi/c/bcd8a4522347

-- 
Martin K. Petersen	Oracle Linux Engineering
