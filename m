Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1789FC2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 01:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2AB72076B
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 01:55:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="msptYCNl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504290AbgJ0BzN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 21:55:13 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52406 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504286AbgJ0BzM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 21:55:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R1o7Ob038782;
        Tue, 27 Oct 2020 01:55:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=yDFM/K9yMuM00gw9MjFpaCvTdtdae5zoXTwTXSqDLD4=;
 b=msptYCNlc4TwmW0hvLinA7e59rWYuzAKqeQQDB5dJ4Jh6Nw4lrVcjClp3ULF6mK3y8KO
 IuL/R9gywy2vmNIGBg+ClKV7TKOyDlurqJa6BYkMxbwCEF6ms0JfwvhBPbpZuwHsnfON
 QBCL/NRj0bhOZTtmSrLcmFrnXCatl+VZgplRsOhb7Por0I0+kHRWkpO5vGzRO0zV8gRT
 hfMEDgkz+dmmNAAocR8BMkJpUQPJXCRi+z+kifDcajqpMZV07cGqUiQ92/qf2uDLuWZw
 qHHupy/fZ11/jLlDwYe+sfHmVnqKKmL7ruoigM880tO4xCFrQNDyDSsAlov3DvtlZwjA UA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34c9saqmfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 01:55:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R1pHYS066907;
        Tue, 27 Oct 2020 01:55:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34cx6vcwa7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 01:55:00 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09R1suW2030550;
        Tue, 27 Oct 2020 01:54:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 18:54:55 -0700
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chris Leech <cleech@redhat.com>, Lee Duncan <lduncan@suse.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com
Subject: Re: [PATCH v3 27/56] scsi: fix some kernel-doc markups
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11rhk5t7e.fsf@ca-mkp.ca.oracle.com>
References: <cover.1603469755.git.mchehab+huawei@kernel.org>
        <8ed7f149f25a363eea76e514c253c4e337c59379.1603469755.git.mchehab+huawei@kernel.org>
Date:   Mon, 26 Oct 2020 21:54:53 -0400
In-Reply-To: <8ed7f149f25a363eea76e514c253c4e337c59379.1603469755.git.mchehab+huawei@kernel.org>
        (Mauro Carvalho Chehab's message of "Fri, 23 Oct 2020 18:33:14 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=969 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=985 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1011 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mauro,

> Some identifiers have different names between their prototypes and the
> kernel-doc markup.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
