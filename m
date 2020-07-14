Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65EBC433E5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 16:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C195B2064C
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 16:50:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MZtjLnyz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgGNQuO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 12:50:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43392 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgGNQuO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 12:50:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EGli7o134803;
        Tue, 14 Jul 2020 16:50:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=wDW+LJY/xmnT0U8mvYNtybMehN5jP3JYQycycM6EqFg=;
 b=MZtjLnyz53tnSf1bGYfuISkZZoXeCnD6A8pq1PQBCn3E7bjq5/OvrDrrpKcEjX+xCHEO
 nzkdmUHxWFvTq3ZM7oRL7/lmXHBdwSjiqUDNgkjNwrHw0m8BCsYjP/6wic9yzQG6iumY
 8nxH+4sketoMPhlxGStNb96NFgfQoJnMXnS1EZTFmqD5aj1NmcTTl7eQv0VcDlJ/2t1Q
 opXajAVDsScL/O20vuOSd9NuSyvOoM8NQOMFPbODkimELqU4j6FSmCegJebSIgfhhiSK
 UXy4q/dzrGG7hu4XuKk0hEfegntCD+Y4s4Y+rjxwmwlGjnsMg1CNt2nEqErwjGEh1nxz zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32762nedux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 16:50:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EGlZEb149400;
        Tue, 14 Jul 2020 16:50:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 327qb4mkr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 16:50:07 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06EGo6Vq031596;
        Tue, 14 Jul 2020 16:50:06 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 09:50:05 -0700
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 05/29] scsi: fcoe: fcoe_ctlr: Fix a myriad of
 documentation issues
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2nmoxcu.fsf@ca-mkp.ca.oracle.com>
References: <20200713074645.126138-1-lee.jones@linaro.org>
        <20200713074645.126138-6-lee.jones@linaro.org>
        <yq1lfjmqji1.fsf@ca-mkp.ca.oracle.com> <20200714142324.GC1398296@dell>
Date:   Tue, 14 Jul 2020 12:50:03 -0400
In-Reply-To: <20200714142324.GC1398296@dell> (Lee Jones's message of "Tue, 14
        Jul 2020 15:23:24 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=1 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140122
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Lee,

> Yes, I spotted it.  Hence my earlier comment to Hannes:
>
>  "Look at the function below it (in your local copy). ;)"
>
> Do you want me to fix that up here as well?

I can fix it up.

-- 
Martin K. Petersen	Oracle Linux Engineering
