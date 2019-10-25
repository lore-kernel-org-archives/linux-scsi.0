Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF3ACA9EAF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 01:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84411205F4
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 01:32:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GeGIRqOF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfJYBb6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 21:31:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60450 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfJYBb6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 21:31:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P1Tqnq148236;
        Fri, 25 Oct 2019 01:31:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=YX6iSuSJzD6bU5Zqg+Y9VBaCEuVJRCJvQMMc8dq7OWs=;
 b=GeGIRqOFHcCZr9lhDl0wY7Q6cc++SgPFYwlc0Rk/pIHYkVF/y5PkKixTrHbfCZaPR40S
 g48gV8wllNV7qBc74C+s6DRo5npG/I7N/RxaXCS6LOu0ch+aGbdN/J+dry6ZJGJm7YRS
 0WepkDHpsjG13Ol3snKybs2RW/gkamZXaeP+mwMNokrbDMzdRg3xaI9UqEIhKJwwAVp8
 50jtQB3NG0Vd356wsWWt5MK0Jb+5aIX864AIAJYjs1A+s+HWOSGRb9zl2zbjHWI0VdUc
 A6tQbXw2mXYeDx/aXJyuJfXyj/KeRGzOtXLMDHUM2NeWqqOEbVuFOF475JbTPD1vLw3R Sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vqswtyb13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 01:31:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P1Stak022517;
        Fri, 25 Oct 2019 01:31:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vunbk6jka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 01:31:46 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9P1VjwH028060;
        Fri, 25 Oct 2019 01:31:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 18:31:45 -0700
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/18] hisi_sas: Misc patches, mostly debugfs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1571926105-74636-1-git-send-email-john.garry@huawei.com>
Date:   Thu, 24 Oct 2019 21:31:43 -0400
In-Reply-To: <1571926105-74636-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Thu, 24 Oct 2019 22:08:07 +0800")
Message-ID: <yq1zhhpa9vk.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=663
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=749 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250014
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> This series introduces a couple of minor improvements in the main
> driver, and mostly changes in the driver debugfs support.
>
> The main change in the driver debugfs support is the ability to take
> multiple memory dumps, which was not available previously. And the
> bulk of the changes here is to create new structures for this purpose.
>
> We also add a new debugfs feature to report PHY down events, which
> seem to be useful to some people.

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
