Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AEDC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 21:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58CCB2078E
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 21:35:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q1YKPxlZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgIOVez (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 17:34:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53174 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbgIOVeJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 17:34:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FLSsfb096450;
        Tue, 15 Sep 2020 21:33:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=/ZV8BZNEd03fxvtY9CpMxHoIUCrJ5P1bP/N01vArI80=;
 b=Q1YKPxlZEsYy5N0Tnl2ekqNrID40kP+/7NzePtlllnoTgp+zYrTlTLv6zCzKEoc4xlcm
 +Gdwvtu0RY6gN2rZ+7afVoE3sUrneyBzdKAlb3UPfpJMu/T8rSG/+EMUot7aAfR7fDBG
 X3BZ/XBRzfhY7ERk4hljKeqf2cSsR8Vga7LiSgbRmK1UdMoIZO77UKX184LfbhrJei9L
 5Nq7pQLYW4BIEDp0u3ipndJHpm73AU6pwaDrD9V1oPUqGuIJ7YP+5butsyWFHllMC/I/
 V9SQH8XmONFFq5j4MhXfpoJDqz8MOAM4I423ubcV1uprC9gIgBG6krzCQ1/WQlMVlnpN hA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33gp9m7ptn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 21:33:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FLTpaf144963;
        Tue, 15 Sep 2020 21:33:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33hm31aj4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 21:33:43 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08FLXcqj024359;
        Tue, 15 Sep 2020 21:33:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 21:33:37 +0000
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <willy@infradead.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: sym53c8xx_2: remove unneeded semicolon
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0wu67z1.fsf@ca-mkp.ca.oracle.com>
References: <20200911091031.2937834-1-yanaijie@huawei.com>
Date:   Tue, 15 Sep 2020 17:33:35 -0400
In-Reply-To: <20200911091031.2937834-1-yanaijie@huawei.com> (Jason Yan's
        message of "Fri, 11 Sep 2020 17:10:31 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150168
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> This addresses the following coccinelle warning:
>
> drivers/scsi/sym53c8xx_2/sym_fw.c:372:3-4: Unneeded semicolon
> drivers/scsi/sym53c8xx_2/sym_fw.c:480:3-4: Unneeded semicolon
> drivers/scsi/sym53c8xx_2/sym_fw.c:536:2-3: Unneeded semicolon

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
