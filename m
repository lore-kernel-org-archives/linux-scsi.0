Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C88BC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 15:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 398602070C
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 15:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389899AbhASPsZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 10:48:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52036 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389189AbhASPrn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 10:47:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JFYIJk150996;
        Tue, 19 Jan 2021 15:46:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=5Uy+Pa/jD4jlnqQSrCyAWcYlvoNXAtFz5RTUmGI3lNY=;
 b=fdd5S2oxBaDpccPX7bb01SE6BFi6TegWpLjD5KeXvBVXiJLJ9nEi3w7amYNcqq0kltU1
 /a9mJUpkxrINyRp+xSoq2e+95tmHWV9K5x0j2eRrOmT2MV2pm3EFkYwWLawObyrsJCQN
 87oQGQrf2U9xe3fx1hLHF2wzdQHqoJSKRWnjStNH/1lNofx0oSUYguZe8+PkGISITPRX
 8PL89TuJLrAlq2xHHwlFXDQ1fQX5TmUL9eQ2W3eGftGiJZOL0ZA7crhITCkD1fRxwLtf
 i1G9R7OIMP59vz62V3eMR8Hjk5zX7bCHbO2ZevtFDfmGpjr6ayAA4oqnoz/MGCMz1rDa /w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 363r3ksp0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 15:46:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JFZj3D083877;
        Tue, 19 Jan 2021 15:46:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3661equw6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 15:46:50 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10JFknfr020344;
        Tue, 19 Jan 2021 15:46:49 GMT
Received: from dhcp-10-154-146-132.vpn.oracle.com (/10.154.146.132)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Jan 2021 07:16:25 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] scsi: qla2xxx: fix description for parameter
 ql2xenforce_iocb_limit
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20210118184922.23793-1-ematsumiya@suse.de>
Date:   Tue, 19 Jan 2021 09:16:25 -0600
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arun Easi <aeasi@marvell.com>, Quinn Tran <qutran@marvell.com>
Content-Transfer-Encoding: 7bit
Message-Id: <9228BCF5-EFDE-4A23-96DB-674554979D44@oracle.com>
References: <20210118184922.23793-1-ematsumiya@suse.de>
To:     Enzo Matsumiya <ematsumiya@suse.de>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190094
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jan 18, 2021, at 12:49 PM, Enzo Matsumiya <ematsumiya@suse.de> wrote:
> 
> Parameter ql2xenforce_iocb_limit is enabled by default.
> 
> Fixes: 89c72f4245a8 ("scsi: qla2xxx: Add IOCB resource tracking")
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index f80abe28f35a..0e0fe5b09496 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -42,7 +42,7 @@ MODULE_PARM_DESC(ql2xfulldump_on_mpifail,
> int ql2xenforce_iocb_limit = 1;
> module_param(ql2xenforce_iocb_limit, int, S_IRUGO | S_IWUSR);
> MODULE_PARM_DESC(ql2xenforce_iocb_limit,
> -		 "Enforce IOCB throttling, to avoid FW congestion. (default: 0)");
> +		 "Enforce IOCB throttling, to avoid FW congestion. (default: 1)");
> 
> /*
>  * CT6 CTX allocation cache
> -- 
> 2.29.2
> 

Good Catch. 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

