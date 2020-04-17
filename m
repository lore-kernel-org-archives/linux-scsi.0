Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACD1C38A2B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 21:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 287BF206B9
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 21:33:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TB3f60E+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgDQVdE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 17:33:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38278 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgDQVdE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 17:33:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HLIDpw080843;
        Fri, 17 Apr 2020 21:32:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=MhHxuUzD8ukv6rCP6gRjeCM6Yx6e3+nf8IaYhV4gdno=;
 b=TB3f60E+K606L/ykrNQuQs0G5d61XvZ3hyPB2GLeVMDN/2cN6cmL8SEg3CcRRi/PXcJ4
 uHEK9BX8WO0ciBfh3eXHAb6G+UPRO5USSti3oqdVnox/JNW9Q/d7To8BQZvuU9h3SiEM
 o9VeTFdv8q4/S9wnm+LlR6YNC4kWkjNO1om2H/Iliggf2uRw9y9U1O1HYNnshNy4HJsB
 T7bDDqDnciEnlBqpdQBD7tx9FhyOfCYwhGxdG4bEGfZtgNX8useRdkaz5w7tPcjWVWDY
 1gm8u+ThjD28kBnmuohDPNNhIcqk5Shv8qfHhPXSd3j4IurJbR1ud0GDB2bt732Z+65N lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30emejs5r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 21:32:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HLVxGM084110;
        Fri, 17 Apr 2020 21:32:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30dyp3jew6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 21:32:55 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03HLWsdi002384;
        Fri, 17 Apr 2020 21:32:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 14:32:54 -0700
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH 1/3] scsi: fnic: make some symbols static
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200415093809.9365-1-yanaijie@huawei.com>
Date:   Fri, 17 Apr 2020 17:32:52 -0400
In-Reply-To: <20200415093809.9365-1-yanaijie@huawei.com> (Jason Yan's message
        of "Wed, 15 Apr 2020 17:38:07 +0800")
Message-ID: <yq1r1wln6gr.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=934 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170155
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> Fix the following sparse warning:

Applied patches 1-3 to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
