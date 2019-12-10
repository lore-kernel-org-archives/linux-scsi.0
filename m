Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 747FEC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 00:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43B5C2080D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 00:19:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jmUwostt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfLJATI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 19:19:08 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45840 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbfLJATH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 19:19:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBA0EeI6034749;
        Tue, 10 Dec 2019 00:18:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=DiSIGrrg5A5qX17v012gADGK485KdP4IIJD/nAa20hk=;
 b=jmUwosttGYomb5hAomEGdPBniWMVGxgW3pTeUsSmVAJ/pEhDJwzU3eQD4CdMl3hzA75N
 eJdg10CCtfyz/YB5vOUlBEYOuk/rVPYOSi2VewV+xJDiDGECO5WNzRlvMJiX7Zn57afE
 4jPouYtYBoDFgybLlcyOCceSy9rsuxmiDv2kiZ0pPaui8HVvSnj5n5viO1i76t/VQqCW
 EvJETzDGI4HmdmP/NvVWtso+n4iRlMVIK2L8nUvpxNGpC12W8T7y/uVf+kHmorhj6HCw
 q8CjJybWJr3HqDnA4czTAjR1/HQq8HdGjdWA0w3hpYQGxHskcGhTCtHDJCdu1uGMrx/F EA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wr4qrau7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 00:18:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBA0IMkW191108;
        Tue, 10 Dec 2019 00:18:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2wsv8atwye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 00:18:51 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBA0IkKN001291;
        Tue, 10 Dec 2019 00:18:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 16:18:46 -0800
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Don Brace <don.brace@microsemi.com>, esc.storagedev@microsemi.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] smartpqi: Update attribute name to `driver_version`
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <fe264d62-0371-ea59-b66a-6d855290ce65@molgen.mpg.de>
Date:   Mon, 09 Dec 2019 19:18:44 -0500
In-Reply-To: <fe264d62-0371-ea59-b66a-6d855290ce65@molgen.mpg.de> (Paul
        Menzel's message of "Mon, 9 Dec 2019 16:06:53 +0100")
Message-ID: <yq17e35owwr.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=889
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912100001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=951 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912100000
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Paul,

> The file name in the documentation is currently incorrect, so fix it.

Applied to 5.5/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
