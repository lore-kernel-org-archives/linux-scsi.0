Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259BDC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 14:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F40B3207FB
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 14:10:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CRfzDXhA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgGNOKU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 10:10:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52066 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgGNOKT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 10:10:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EE2tFA063176;
        Tue, 14 Jul 2020 14:10:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=TzjPuar5m/sU1Kxr0G5mH0KefF/L9/miLnhjaaNayYU=;
 b=CRfzDXhAhkA9dduDfnebqN8nemG7DrdZRi+CNJGu+oXj7buHlq/qoxE7iHMaXZWl9oMC
 2b060n5j+yAFiQ/vxDtioHdnYxDr7A98O63b9Qj9aKT8UGMu3wmEvfpyFN7y9MAPjsfs
 zRu3E2xDaci9406P3qUWUBMW3FYBDZTstuSojeGaFE4tXrfMMkE+Qac7tEGhjz3lCfw7
 RD9F2TyVqbMAqK1jTUrCDJVomoYlG5iSNcaS2WlBA1hXVpHhdCbGPCAVEFpBMwr3qMkf
 8KGXzeegOi4u2vvy1otqyO+Pi3M++ASrKRxjqNkcbhyI8s9HHl6bCL4RPGVMqgm8y/Ce RA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3275cm5jey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 14:10:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EE7Zpo012005;
        Tue, 14 Jul 2020 14:08:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 327qb469yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 14:08:13 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06EE8BCe013273;
        Tue, 14 Jul 2020 14:08:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 07:08:10 -0700
To:     Lee Jones <lee.jones@linaro.org>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 05/29] scsi: fcoe: fcoe_ctlr: Fix a myriad of
 documentation issues
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lfjmqji1.fsf@ca-mkp.ca.oracle.com>
References: <20200713074645.126138-1-lee.jones@linaro.org>
        <20200713074645.126138-6-lee.jones@linaro.org>
Date:   Tue, 14 Jul 2020 10:08:08 -0400
In-Reply-To: <20200713074645.126138-6-lee.jones@linaro.org> (Lee Jones's
        message of "Mon, 13 Jul 2020 08:46:21 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=5 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140108
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Lee,

> @@ -3015,9 +3016,8 @@ static void fcoe_ctlr_disc_recv(struct fc_lport *lport, struct fc_frame *fp)
>  	fc_frame_free(fp);
>  }
>  
> -/**
> +/*
>   * fcoe_ctlr_disc_recv - start discovery for VN2VN mode.
> - * @fip: The FCoE controller
>   *
>   * This sets a flag indicating that remote ports should be created
>   * and started for the peers we discover.  We use the disc_callback

s/fcoe_ctlr_disc_recv/fcoe_ctlr_disc_start/ ?

-- 
Martin K. Petersen	Oracle Linux Engineering
