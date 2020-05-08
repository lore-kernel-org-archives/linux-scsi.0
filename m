Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEDAC4724C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D6B920731
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:55:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aXltXqTs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgEHCzB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:55:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43856 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbgEHCy7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:54:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482s7Ll011067;
        Fri, 8 May 2020 02:54:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=hl1hklBxICdkL40oT0xXP4xn0/22pEFlkGVbJkOXKbU=;
 b=aXltXqTsCysz0cxXJmra4ZRWsccCPdS/Z3qDn/+x37eN5O3amngGH1tn4esJ2M+MuqHb
 06KfuyTSfKswOwnInL3A4zzCIlPNhUKP2g6ODY19t6lUvVKUe/8XpZ1ZslcAokrtmfYA
 2UNhfUvOGmdcwZe8hay4xVvKabz4ARIDQUfMsz63HiXxCG/oZj9jQkv9A9FAtQqxhuy0
 yQsPng63flflTb3+NIYhc0k8sL3zZAWRlMhx7REzr6RqOPPh8485jB3URXy9U7Kb0AuA
 7JaSSwHPktMwdqjcg6pq3arT36O9ejue4XujooiM94MMluiS2xhmdz77DfVg5z0//fWr 1g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30vtewrrr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482qgkW012609;
        Fri, 8 May 2020 02:54:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30vtefqnf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:51 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0482sog7024631;
        Fri, 8 May 2020 02:54:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 19:54:50 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Zou Wei <zou_wei@huawei.com>,
        aacraid@microsemi.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] scsi: aacraid: Make some symbols static
Date:   Thu,  7 May 2020 22:54:36 -0400
Message-Id: <158890633245.6466.12016958171651569161.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1588240932-69020-1-git-send-email-zou_wei@huawei.com>
References: <1588240932-69020-1-git-send-email-zou_wei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxlogscore=997 bulkscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 30 Apr 2020 18:02:12 +0800, Zou Wei wrote:

> Fix the following sparse warnings:
> 
> drivers/scsi/aacraid/linit.c:867:6: warning:
> symbol 'aac_tmf_callback' was not declared. Should it be static?
> drivers/scsi/aacraid/linit.c:1081:5: warning:
> symbol 'aac_eh_host_reset' was not declared. Should it be static?
> drivers/scsi/aacraid/commsup.c:2354:5: warning:
> symbol 'aac_send_safw_hostttime' was not declared. Should it be static?
> drivers/scsi/aacraid/commsup.c:2383:5: warning:
> symbol 'aac_send_hosttime' was not declared. Should it be static?

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: aacraid: Make some symbols static
      https://git.kernel.org/mkp/scsi/c/297083f6e53b

-- 
Martin K. Petersen	Oracle Linux Engineering
