Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A88C2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 03:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE2BB20825
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 03:04:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mawqKbx1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732694AbgKEDE7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 22:04:59 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35288 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbgKEDE7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 22:04:59 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A52xTfm009936;
        Thu, 5 Nov 2020 03:04:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=z1vaDZ6JhTPotVnBon0GJWwMHIoIgTZVgRpxbBayyD0=;
 b=mawqKbx1N+zVgCp1jfkhG0J3RMY63Xl4H/MiBv5CQXs/7aW32XgJmnKvuq3oJnhxP9+C
 cCjp07JqO8zn8EjJRqIuec2Xk1ZP/kCuH2kd2G7l6vJqaU0aHin/alcSpJzhon5RVbcd
 V6yBZjainfWtI8u487WtVoF3K44tYc7guhvPeinZ83M67CG9egQEK8t/NoWbxRoBGu4g
 Cwsx+Uo6rq0MtVTkAf4vZ/KUD/+AEt44v6WPVZGx6/oyQi6535/i6G+a6lcLHi6NllVt
 QJckKwzBaXUmyNvklOGHs/Gz8OIsUrQ5AzJtAXRxN3dgeD4A/l9EuZA3Y7Vd3jwvqJvz ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34hhvchu6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 05 Nov 2020 03:04:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A530st3132588;
        Thu, 5 Nov 2020 03:04:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34jf4bc8t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Nov 2020 03:04:53 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A534ld3015985;
        Thu, 5 Nov 2020 03:04:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Nov 2020 19:04:47 -0800
To:     trix@redhat.com
Cc:     skashyap@marvell.com, jhasan@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: bnx2fc: remove unneeded semicolon
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z6ktsfv.fsf@ca-mkp.ca.oracle.com>
References: <20201101143812.2283642-1-trix@redhat.com>
Date:   Wed, 04 Nov 2020 22:04:45 -0500
In-Reply-To: <20201101143812.2283642-1-trix@redhat.com> (trix@redhat.com's
        message of "Sun, 1 Nov 2020 06:38:12 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=3 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=874 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=3
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=886
 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tom,

> A semicolon is not needed after a switch statement.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
