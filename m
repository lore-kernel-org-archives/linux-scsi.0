Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E59C433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 03:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9454D208E4
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 03:42:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LxrJMDg/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgGUDmX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 23:42:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42704 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGUDmW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 23:42:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L3bgFC111303;
        Tue, 21 Jul 2020 03:42:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=YN++hbwgWE9+Q7LCmF3JX3M2Kh++JVXvGGZuY3tpdak=;
 b=LxrJMDg/BL4TTCFlDpgmlFnBni+2VShiY6vocGIGScIUkeVcg6IQmfhcdF9Mn3qlu92z
 FgQh6A4jAq/9Cb+PVwTSnG9WzmbmgMZartxuJdzeqBrvpXjI4/iQ3Z9o1wP1gMl/NqmB
 Yz8xXyxvycsSE7khKqync+/j2jIKXiM+DcBoBq6LEosra1D/N/o8CFsetkUxp3KxOZDY
 ehfYxrYYvYCQjGAOSiORFK0xd0gZ+D2xqVELVopbc9gZ75d0q3eCF+ogk6D0+GzIqjfO
 DO1MRtb2UAK1ML8o6SB84VmsC/RtTZ7zWgeO0FOCGnDPz7uPDcZ6VOXO2iTLixfTG5T9 fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32bs1mae06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Jul 2020 03:42:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L3fkxV016424;
        Tue, 21 Jul 2020 03:42:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32dnafpsrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 03:42:15 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06L3gDnn015548;
        Tue, 21 Jul 2020 03:42:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 20:42:13 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] SCSI: scsi_transport_iscsi.h: drop a duplicated word
Date:   Mon, 20 Jul 2020 23:42:08 -0400
Message-Id: <159530290480.22526.11377111336222512447.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200719003232.21301-1-rdunlap@infradead.org>
References: <20200719003232.21301-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210023
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 18 Jul 2020 17:32:32 -0700, Randy Dunlap wrote:

> Drop the repeated word "the" in a comment.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: scsi_transport_iscsi: Drop a duplicated word
      https://git.kernel.org/mkp/scsi/c/05b18b1eb3eb

-- 
Martin K. Petersen	Oracle Linux Engineering
