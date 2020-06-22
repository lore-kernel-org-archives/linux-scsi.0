Return-Path: <SRS0=lGnU=AD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCADC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 22:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4BC420716
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 22:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dwe5VeU6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730845AbgFVWJt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 18:09:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54216 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730763AbgFVWJt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2020 18:09:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MM7dQT011765;
        Mon, 22 Jun 2020 22:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=8HbMXk+KoKG34BzP8DnetEyz8h21Mo0123hkyVAfSzw=;
 b=dwe5VeU6K7Y+lKjnmHlBC26IVYxOB3Owj4vKrVroe5PA67Ews4IrdqAHEu1nG835KbQF
 akWIrYqlMt/bxy6i/TYEmqXGiFl16FeMWI4gleBBR05gH2wzSVWeKkTknEQyiZxJ2NIV
 Ao8UEA8E4gcyVDE6yb7rhDfhjtAoqDWqt1Z5Bcy1J1RJwYEpYxBRMsFW7jnLUN6KL8IP
 1zAzW+R1ugeO1/anz+8TI6hDXLaFAMxydoYnx+snf1lkWrwNNCJONhSnRocTyaNfHq2A
 Z/RyavA5mdrTPKyghr18SlUabIQalR7TEGL0Mct3268obGeQDDt8k99I/9iEqSwzMv7y 8A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31sebb9xrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 22 Jun 2020 22:09:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MM35SJ007499;
        Mon, 22 Jun 2020 22:07:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31svcvt7yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 22:07:45 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05MM7igR003811;
        Mon, 22 Jun 2020 22:07:44 GMT
Received: from [192.168.1.25] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Jun 2020 22:07:44 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH 0/9] qla2xxx patches for kernel v5.9
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200614223921.5851-1-bvanassche@acm.org>
Date:   Mon, 22 Jun 2020 17:07:43 -0500
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <EAC19A51-7256-4D5D-9DBB-D30CEF8551E9@oracle.com>
References: <20200614223921.5851-1-bvanassche@acm.org>
To:     Bart Van Assche <bvanassche@acm.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006220143
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jun 14, 2020, at 5:39 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> 
> Hi Martin,
> 
> Please consider these patches for kernel v5.9.
> 
> Thanks,
> 
> Bart.
> 
> Bart Van Assche (9):
>  qla2xxx: Check the size of struct fcp_hdr at compile time
>  qla2xxx: Remove the __packed annotation from struct fcp_hdr and
>    fcp_hdr_le
>  qla2xxx: Make qla82xx_flash_wait_write_finish() easier to read
>  qla2xxx: Initialize 'n' before using it
>  qla2xxx: Remove several superfluous casts
>  qla2xxx: Make __qla2x00_alloc_iocbs() initialize 32 bits of
>    request_t.handle
>  qla2xxx: Fix a Coverity complaint in qla2100_fw_dump()
>  qla2xxx: Make qla2x00_restart_isp() easier to read
>  qla2xxx: Introduce a function for computing the debug message prefix
> 
> drivers/scsi/qla2xxx/qla_bsg.c     |  3 +-
> drivers/scsi/qla2xxx/qla_dbg.c     | 98 +++++++++++-------------------
> drivers/scsi/qla2xxx/qla_init.c    | 39 ++++++------
> drivers/scsi/qla2xxx/qla_iocb.c    |  4 +-
> drivers/scsi/qla2xxx/qla_mr.c      |  3 +-
> drivers/scsi/qla2xxx/qla_nx.c      | 20 +++---
> drivers/scsi/qla2xxx/qla_target.h  |  4 +-
> drivers/scsi/qla2xxx/tcm_qla2xxx.c |  1 +
> 8 files changed, 71 insertions(+), 101 deletions(-)
> 

Looks Good.

For the series Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering





