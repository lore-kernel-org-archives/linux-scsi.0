Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ABEDC43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0059A24672
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WL7sNWwo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfLSXms (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 18:42:48 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50950 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbfLSXmr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 18:42:47 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJNT1RG073665;
        Thu, 19 Dec 2019 23:42:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=KNRIyfZSJc+sjlf8AW3DFIlS8Wtqq0EnLmZ5K7qfYvs=;
 b=WL7sNWwo/0RD9I0z/e/n8tKGgvAhxc9kAWdKuYyO7Pvu9dGu7dmswHuD6CQL7Je8SQ4L
 MCKx/UGFI4E8WE54Bv1fPJowqkRZ4k7DYQJGTl/wtFk3RYJ6VmS2GScqKkgoEN3FwUco
 N0MinKqBfODLk4aUOurRb31nJbrt5w3VOa6vICpwTXZW9HUXcQNwTyIGLXMGdI6MXh5K
 0aiCMhdKa+oR3K83bJMn6yAuGuLwNk0LYEUT30iRqDo2lrn3hc81OT9jPwauJaR16UOU
 vo/jXZKNA4KukD5tcwI4YhsCw5egLEbSGyHGNSWQzFY6GeGewc3RhwM7DhQejSD1Vq9y bA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2x0ag12w33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 23:42:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJNYHdV011170;
        Thu, 19 Dec 2019 23:42:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wyut62sgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 23:42:40 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBJNgdNc009768;
        Thu, 19 Dec 2019 23:42:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Dec 2019 15:42:38 -0800
To:     Chen Zhou <chenzhou10@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH next] scsi: initio: make initio_state_7() static
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191217134309.41649-1-chenzhou10@huawei.com>
Date:   Thu, 19 Dec 2019 18:42:36 -0500
In-Reply-To: <20191217134309.41649-1-chenzhou10@huawei.com> (Chen Zhou's
        message of "Tue, 17 Dec 2019 21:43:09 +0800")
Message-ID: <yq1d0cjc26r.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912190173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912190173
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chen,

> Fix sparse warning:
>
> drivers/scsi/initio.c:1643:5: warning: symbol 'initio_state_7' was not declared. Should it be static?

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
