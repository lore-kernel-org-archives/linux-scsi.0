Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD09C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 23:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17E6D2078D
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 23:38:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mvarrubc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgIOXhw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 19:37:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38984 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgIOXhl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 19:37:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FKApmH178727;
        Tue, 15 Sep 2020 20:16:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xlGgE+xgKVH5MYRF5RiIp0Sd3bdxAx8PeATXeLm7Jp0=;
 b=MvarrubcPB6fTB8zTJxIyN8Tx1JCErDSJ3Sw4K/W7h22S0Iy/5u6V7Xr4vo+v5VSO2le
 WWB+3g3gdCZVVt6BS7z3c9Z0MvOaB5KH2G/f0FumJDjR59TcLP6tpU3PutixMjgwAZN+
 pZtEDemIzKyim5WYzj+kCzEMjdW/bFwJhcO3KRKf8DlFKq/NUgk1lH1xhbveQTWumCc+
 DQvP08WyZ4Y4SIRNaBDT3iQ9K0TiJPp1t6az5/WA+J++nFU7Dj/fUkfVu4tTvR9CY964
 /nBASWyf4W3aJeRuc6/ncxpgMuJC9CAfNOrfLwNBLSGFZSYDCLCs55X5TW4vcaGEgWPN PQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33j91dh103-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 20:16:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FKFREv177269;
        Tue, 15 Sep 2020 20:16:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33h885xmny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 20:16:47 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08FKGgu9006688;
        Tue, 15 Sep 2020 20:16:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 20:16:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     =?UTF-8?q?N=C3=ADcolas=20F=20=2E=20R=20=2E=20A=20=2E=20Prado?= 
        <nfraprado@protonmail.com>, Jonathan Corbet <corbet@lwn.net>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrealmeid@collabora.com, lkcamp@lists.libreplanetbr.org,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: docs: Remove obsolete scsi typedef text from scsi_mid_low_api
Date:   Tue, 15 Sep 2020 16:16:27 -0400
Message-Id: <160020074002.8134.4034144362404151675.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200905210211.2286172-1-nfraprado@protonmail.com>
References: <20200905210211.2286172-1-nfraprado@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150157
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 05 Sep 2020 21:03:00 +0000, Nícolas F. R. A. Prado wrote:

> Commit 91ebc1facd77 ("scsi: core: remove Scsi_Cmnd typedef") removed
> the Scsi_cmnd typedef but it was still mentioned in a paragraph in the
> "SCSI mid_level - lower_level driver interface" documentation page.
> Remove this obsolete paragraph.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: docs: Remove obsolete scsi typedef text from scsi_mid_low_api
      https://git.kernel.org/mkp/scsi/c/5476b7f5ae7b

-- 
Martin K. Petersen	Oracle Linux Engineering
