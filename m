Return-Path: <SRS0=5qjn=YP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC873CA9EA0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 21:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91513214B2
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 21:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732128AbfJVVL1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Oct 2019 17:11:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62902 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731558AbfJVVL1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Oct 2019 17:11:27 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9ML9xAB035139;
        Tue, 22 Oct 2019 17:11:21 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vt9err1tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Oct 2019 17:11:21 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x9MLAJWo016695;
        Tue, 22 Oct 2019 21:11:20 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma05wdc.us.ibm.com with ESMTP id 2vqt47hy99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Oct 2019 21:11:20 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9MLBJXt39846350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 21:11:19 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9678124055;
        Tue, 22 Oct 2019 21:11:19 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CB33124053;
        Tue, 22 Oct 2019 21:11:19 +0000 (GMT)
Received: from p8tul1-build.aus.stglabs.ibm.com (unknown [9.3.141.206])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue, 22 Oct 2019 21:11:19 +0000 (GMT)
Date:   Tue, 22 Oct 2019 16:11:15 -0500
From:   "Matthew R. Ochs" <mrochs@linux.ibm.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     manoj@linux.ibm.com, ukrishn@linux.ibm.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] scsi: cxlflash: remove set but not used variable
 'ioarcb'
Message-ID: <20191022211115.GA2429@p8tul1-build.aus.stglabs.ibm.com>
References: <20191021141957.18828-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021141957.18828-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-22_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=844 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910220179
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 21, 2019 at 10:19:57PM +0800, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/scsi/cxlflash/main.c:47:22: warning:
>  variable ioarcb set but not used [-Wunused-but-set-variable]
> 
> It is never used, so can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Matthew R. Ochs <mrochs@linux.ibm.com>

