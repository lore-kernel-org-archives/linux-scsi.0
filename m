Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C03CC4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 01:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01A5A2085B
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 01:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VvKmmKkr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504043AbgJ0Bp1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 21:45:27 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46188 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440652AbgJ0Bp1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 21:45:27 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R1jA0Q035495;
        Tue, 27 Oct 2020 01:45:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=AeD8TWWu3el0Q85RqIfxPguc0gpyZoEIcK/Kf1acmEI=;
 b=VvKmmKkryqSzt4GxYkieJunxEx7f+QNqOlIv74+pSDOIxzqx/PnlVO7+24Eqf/5p5liC
 EgL3EX/b4ba5H26Eie+cXd72GoY0WCTp0xuhtz5Mplqx4/nChFN0k2YlGZ/HEq1+y9WC
 7CvJd/Npfg7XNbWCbq3pz+AVsiS4Gg6jIZmeAVOSx52tenn45jH6yopOTH3ct09DabhZ
 vc9CPpX5sOgJTeqg31idkD/mnetiKJzKs6YwvFAMeJdiqF8XN2tcNAmXgqC97L6k0ZEJ
 2+ATdZ0EhF5XeHKSlggsEKGbQKUckvc6hAE9WppOP5C0XNDFXgdvyfzk2nBA0hDNbx6h jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9saqkyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 01:45:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R1e0uT018954;
        Tue, 27 Oct 2020 01:43:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34cx5wj47s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 01:43:25 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09R1hOGj017890;
        Tue, 27 Oct 2020 01:43:24 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 18:43:19 -0700
To:     James Smart <james.smart@broadcom.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/9] lpfc: Update lpfc to revision 12.8.0.5
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17drc5tqt.fsf@ca-mkp.ca.oracle.com>
References: <20201020202719.54726-1-james.smart@broadcom.com>
Date:   Mon, 26 Oct 2020 21:43:17 -0400
In-Reply-To: <20201020202719.54726-1-james.smart@broadcom.com> (James Smart's
        message of "Tue, 20 Oct 2020 13:27:10 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=1 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270011
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 12.8.0.5
>
> Patches include several small fixes and the addition of a FDMI
> registration for vendor MIB data.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
