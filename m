Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F086EC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 03:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0CFB23122
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 03:28:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n3m7OKnY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732731AbgFTD2s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 23:28:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59872 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732724AbgFTD2s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 23:28:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05K3IrwA195240;
        Sat, 20 Jun 2020 03:28:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=2CzZq5GU6wgRj+8UAuT73tB62Tj9OsO+caXjTCosPng=;
 b=n3m7OKnY07P9PV4DmDKP+ivWEMnsJKZTHvqbV2INUUxd5JtiQAFikGd0ifDeq+UtVwYZ
 FiKi6A9hVGGa0NIuyeLjS0fRmBerfAox9qpsmgeLqL7KIz54+HZgYh+37ON055I24eMH
 jsMTodWI0YIPZwBCH9wKfmXXmnmjmXI+JBE234UjcIHFLJMLk2cP6zyZhOU/EeFtvoNP
 WnMMM+KYtp3jrPSe0UmgL3U37I1cEkEDHVroTfauuoTV/I8/dYgFC0oiD6hIKEHU5op+
 SF35ctm4w/UfqLTv/4GqPoUWzeaEAo5KFB7wR9ePff0PcDQTHIWSK0W5lTp6YUB1doQt vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31s9vqr1yu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 20 Jun 2020 03:28:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05K3JI5A035764;
        Sat, 20 Jun 2020 03:26:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31s8g8c4u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Jun 2020 03:26:42 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05K3QdXq011083;
        Sat, 20 Jun 2020 03:26:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jun 2020 20:26:39 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     cang@codeaurora.org, Asutosh Das <asutoshd@codeaurora.org>,
        gregkh@google.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] Documentation:sysfs-ufs: Add WriteBooster documentation
Date:   Fri, 19 Jun 2020 23:26:33 -0400
Message-Id: <159262354734.7800.7343859411228839862.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1591723067-22998-1-git-send-email-asutoshd@codeaurora.org>
References: <1591723067-22998-1-git-send-email-asutoshd@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 phishscore=0 mlxlogscore=895 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006200022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 malwarescore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=929 mlxscore=0 phishscore=0 cotscore=-2147483648 spamscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006200022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 9 Jun 2020 10:17:46 -0700, Asutosh Das wrote:

> Adds sysfs documentation for WriteBooster entries.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: ufs: docs: Add WriteBooster documentation
      https://git.kernel.org/mkp/scsi/c/f51853fc0682

-- 
Martin K. Petersen	Oracle Linux Engineering
