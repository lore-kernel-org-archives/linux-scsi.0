Return-Path: <SRS0=AAGU=DU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75ACEC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 145FE21D7F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:43:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hKJvHT2+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgJMWnM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 18:43:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34206 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgJMWnM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 18:43:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMYSSM023476;
        Tue, 13 Oct 2020 22:43:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KdJQMGQajIDqhW/r3rbvY/DYw7FYlhalRhhC4/BZ1cE=;
 b=hKJvHT2+R5RYjJlrBtwNsUJe65OX7RuSH0yDvLvrqZl6uPpEK8SuMjSDJoePFqMquQrJ
 wjytIuJY5fDEgr0cPuEyYTHqRzusNI727He/dlYCWHnKpC0q6VBe49Oi9ArlnhtnwAeD
 8sJ9JPYYPhaiNClGPpOg2xSj3IMoaK89jYTw297CHpp8v6rdIthWquiPt6CXA/OQ++L+
 odBBQ5s0WD05fWIjPLNvP5kWTTsEyzAAZGLL9H76JHVzUpJDOeQgkqkxhCe1qNUfW/rT
 h9c61TncrXw94I2gYyGwS0doQSwhOBVIB+F5kWmV2SjRqI94ER8daw0vy7nD5Y/fveAt nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3434wkmr75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:43:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMaWb6049028;
        Tue, 13 Oct 2020 22:43:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 343pvx1skf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:08 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09DMh635014503;
        Tue, 13 Oct 2020 22:43:07 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:06 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, intel-linux-scu@intel.com,
        artur.paszkiewicz@intel.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: isci: Fix a typo in a comment
Date:   Tue, 13 Oct 2020 18:42:44 -0400
Message-Id: <160262862435.3018.12705763846359553675.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201003055709.766119-1-christophe.jaillet@wanadoo.fr>
References: <20201003055709.766119-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=983 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 3 Oct 2020 07:57:09 +0200, Christophe JAILLET wrote:

> s/remtoe/remote/
> and add a missing '.'

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: isci: Fix a typo in a comment
      https://git.kernel.org/mkp/scsi/c/45660591ee8f

-- 
Martin K. Petersen	Oracle Linux Engineering
