Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5C5C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D995C21927
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:53:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QT37i+rE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfLSXxK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 18:53:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37378 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfLSXxK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 18:53:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJNnheR092452;
        Thu, 19 Dec 2019 23:53:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=IOAevKSgu4HyS0J5Cpr/uD26hsiJUKyCo1KcIHUOt/k=;
 b=QT37i+rEFTeKnIeL2aAHL6tZ1iWAjbIHprU190flLdKlKnwKlx62j6L7oOFLJzt3ct3c
 osh2QJVJwA7+Pl21r6cZ4kiEHuCTWmLIJ9ZsvSxXlB2jKLwtJOURW6jp35D/4ttFWctr
 pMohbi+EcExn5rm2F6gFk0+o0tWNhDNROPpu9hJlqe+bqw+IPCI6CJLVwHYuGRLHNsFL
 td+1G6GxT0HcmDZ1/8eYc4hzWosVtuvnv3hItTcXskaiSD9oFFCrAYRB8CWpJqk3eRre
 fSp/i+91W8qLQvUIyg/RzC9cevE7Xxp1kbNpN2K4HK2MWUj7UkUXJQE9SNwDS/MZ3Uuc Vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x01knnw27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 23:53:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJNnVpT013896;
        Thu, 19 Dec 2019 23:53:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2x04ms8xg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 23:53:05 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBJNr4Zc014111;
        Thu, 19 Dec 2019 23:53:04 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Dec 2019 15:53:04 -0800
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] scsi: csiostor: Adjust indentation in csio_device_reset
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191218014726.8455-1-natechancellor@gmail.com>
Date:   Thu, 19 Dec 2019 18:53:01 -0500
In-Reply-To: <20191218014726.8455-1-natechancellor@gmail.com> (Nathan
        Chancellor's message of "Tue, 17 Dec 2019 18:47:26 -0700")
Message-ID: <yq1immban4y.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=947
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912190174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912190174
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nathan,

> Clang warns:
>
> ../drivers/scsi/csiostor/csio_scsi.c:1386:3: warning: misleading
> indentation; statement is not part of the previous 'if'
> [-Wmisleading-indentation]
>          csio_lnodes_exit(hw, 1);
>          ^
> ../drivers/scsi/csiostor/csio_scsi.c:1382:2: note: previous statement is

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
