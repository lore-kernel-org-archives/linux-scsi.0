Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6B7C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 02:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7A0A21D7E
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 02:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f7hB1InU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbgIJCnI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 22:43:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43118 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730750AbgIJCko (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 22:40:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A2cvZi134619;
        Thu, 10 Sep 2020 02:40:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=oD53TdEOPBSWk/auD5fMUxEjd71HD4urutJD88VtYF0=;
 b=f7hB1InULYrggUB2gvGysEEEN6vHFRYMOu68QOSWFnuOLt4Ygqfz/vRumSuCK3kmUaef
 ewB7WYgd0yOfJ3AF7zc3oWhKehpfsFS6oF3oom4l+8WWACI8mvpp19J8+wYk6wBilmUb
 oTWmW4CpdAk8lR8nAhbLEiuP6vqdDNqVV86dmve0hxgUzWXAdopeHl6PGOKheS37s1iU
 WuysDD66Yu11Cau1LD1J3ujBgFZiE3PYnZV07hNgVsuSo+Rjp8rI5X1YiXX1Cl4DSJh9
 bRAFkMyAgdI/N8CLTk8CYDi/1V6Nk4AO3o0ONf+p5UVeGzs3rUUj4Bjaa8LJ1oOtT8MJ Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33c2mm58tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 02:40:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A2ZcjB034421;
        Thu, 10 Sep 2020 02:38:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33dacmevs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 02:38:27 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08A2cOgf015967;
        Thu, 10 Sep 2020 02:38:25 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 19:38:24 -0700
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <mdr@sgi.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <tbogendoerfer@suse.de>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/4] scsi: qla1280: some code cleanups to shut up robots
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2li1hm7.fsf@ca-mkp.ca.oracle.com>
References: <20200907074518.2326360-1-yanaijie@huawei.com>
Date:   Wed, 09 Sep 2020 22:38:22 -0400
In-Reply-To: <20200907074518.2326360-1-yanaijie@huawei.com> (Jason Yan's
        message of "Mon, 7 Sep 2020 15:45:14 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 suspectscore=1 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100024
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> Continue to address some build warnings to make our robots happy.
>
> Jason Yan (4):
>   scsi: qla1280: remove set but not used variable in qla1280_done()
>   scsi: qla1280: remove set but not used variable in
>     qla1280_nvram_config()
>   scsi: qla1280: remove set but not used variable in
>     qla1280_mailbox_command()
>   scsi: qla1280: remove set but not used variable in
>     qla1280_status_entry()

Applied to the 5.10 staging tree. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
