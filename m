Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F5EC433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DEB820773
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:01:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xpouQxbz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgICDBN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 23:01:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48178 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbgICDBM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 23:01:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08330F0E122552;
        Thu, 3 Sep 2020 03:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=N8qL/x90uiHspNzecCNtx8L8iX/xPosX2/8GL3DH91g=;
 b=xpouQxbz9j7rq2pYF80EVGVHCPhuZLpnlI4fG4fNyQyfiVP9q03H/AZjmIeI7R0ZxKK9
 suJx+0neZzZS/F5GKaWFYiyKbDDndYaWvvgzUo/O/IsqhPex/7OQKFMVdevm/mAUBujT
 fu7qkzhs0dWDGNmcMQtBcNA5zP/QQ2W5kN31kdnhtBxA7XxglknoFnQC6Ej8BusVa+0Q
 9SUv3urW1oA3NVjkNjqTEiFU7STIHudt3rFLDm/Qf5vFcBOO/en6HMI1c6Cl6FRMP19c
 REmVaPO6bplC14R2wm0bX9ctcoZyIDxcMfgzdoSfUdVJFRw8tNRXXYayHVewGuhMKmFF 5g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 337eyme4ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Sep 2020 03:01:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0832tuwY153208;
        Thu, 3 Sep 2020 03:01:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3380y10h03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Sep 2020 03:01:09 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 083318vs009103;
        Thu, 3 Sep 2020 03:01:08 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 20:01:08 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/4] lpfc: Update lpfc to revision 12.8.0.4
Date:   Wed,  2 Sep 2020 23:00:59 -0400
Message-Id: <159910202092.23499.17308164474517337581.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200828175332.130300-1-james.smart@broadcom.com>
References: <20200828175332.130300-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 28 Aug 2020 10:53:28 -0700, James Smart wrote:

> Update lpfc to revision 12.8.0.4
> 
> The patches were cut against Martin's 5.9/scsi-queue tree
> 
> James Smart (4):
>   lpfc: Fix setting irq affinity with an empty cpu mask.
>   lpfc: Fix FLOGI/PLOGI receive race condition in pt2pt discovery
>   lpfc: Extend the RDF FPIN Registration descriptor for additional
>     events
>   lpfc: Update lpfc version to 12.8.0.4
> 
> [...]

Applied to 5.9/scsi-fixes, thanks!

[1/4] scsi: lpfc: Fix setting IRQ affinity with an empty CPU mask
      https://git.kernel.org/mkp/scsi/c/7ac836ebcb15
[2/4] scsi: lpfc: Fix FLOGI/PLOGI receive race condition in pt2pt discovery
      https://git.kernel.org/mkp/scsi/c/7b08e89f98ce
[3/4] scsi: lpfc: Extend the RDF FPIN Registration descriptor for additional events
      https://git.kernel.org/mkp/scsi/c/441f6b5b097d
[4/4] scsi: lpfc: Update lpfc version to 12.8.0.4
      https://git.kernel.org/mkp/scsi/c/bc5340693749

-- 
Martin K. Petersen	Oracle Linux Engineering
