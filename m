Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71651C2D0E0
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 395BF20936
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:09:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QIXDwpt8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgIICJp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:09:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41588 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728663AbgIICJm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:09:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08921K1r087384;
        Wed, 9 Sep 2020 02:09:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=4CqmJ7R4wLu3OMpPhZjP+7xMm8hxdl5DwRkUZvj5LbU=;
 b=QIXDwpt8uz90/VxuZM03lLAzUiA8GoxeK4fJ9IMIj7avzEPNOlIsFG617xe+FKdAxjn2
 imn3Kfr2rpoc37EDe5H8dVGj7Ufo1PpPy2WcROwENs4gQrcUlrgPuKQJZE0Tp+vHz4hv
 Q6E5+bs0B/5tAZf5kgS3jvMxB+cWQLmXEw8B6vr4UlK5Gfy8KClFJ+mpZfkfWbJSbZDa
 yUONCPuv4Zali3Dsx6Si6dojwhnW9wKGnf2l3EVTvY9aGsdRT7gg9JGRdWavLYtNQqcz
 +IsfMzcMQ96DKXFHDJ79tTEjAkfDOVBBRqfVFACdtQCmt9IX1Rwjrh7um2yXcRFrivCE cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33c2mkxvmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:09:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 089252vi095435;
        Wed, 9 Sep 2020 02:09:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33cmk53ehn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:09:32 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08929TNZ006942;
        Wed, 9 Sep 2020 02:09:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:09:28 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Don Brace <don.brace@microsemi.com>, POSWALD@suse.com,
        Justin.Lindley@microchip.com, hch@infradead.org,
        joseph.szczypek@hpe.com, gerry.morong@microchip.com,
        Kevin.Barnett@microchip.com, scott.benesh@microchip.com,
        scott.teel@microchip.com, jejb@linux.vnet.ibm.com,
        mahesh.rajashekhara@microchip.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] hpsa: update copyright
Date:   Tue,  8 Sep 2020 22:09:10 -0400
Message-Id: <159961731707.5787.2443733311608793231.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <159864166227.12131.3427629298809272795.stgit@brunhilda>
References: <159864166227.12131.3427629298809272795.stgit@brunhilda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=953 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=985
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 28 Aug 2020 14:07:42 -0500, Don Brace wrote:

> * Add entry for Microchip

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: hpsa: Update copyright
      https://git.kernel.org/mkp/scsi/c/9e21760e4ce4

-- 
Martin K. Petersen	Oracle Linux Engineering
