Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA9E0C38A29
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 21:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8A2421744
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 21:35:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pV2FmzW+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgDQVfb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 17:35:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36334 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgDQVfb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 17:35:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HLILig016868;
        Fri, 17 Apr 2020 21:32:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Bjf1q6zUnnLKrptK1UtiDhBftkswIaoiuIfxtbTFFUI=;
 b=pV2FmzW+nsi1iJT4Cz8R+skuOgki0Y/nfLUYAjVofl1rREN4Gw3uHIRE/ly7o5WnThi6
 OUzfCd1BscjAPw29ay7hU7Azmc4T1bi+fhHgN8zdHb6z2SSsHadyUVGDTSPnAo5b6p3d
 z84AGlAkeVs6x5L3QqeZ7tHoPwg/Nv4TJtAd7b01c2NQAGsDucvdv18j7qJgTRqwAi87
 d3geB+JEG0s92UvJFDAbG2kfsIapMxBtLXxwqilg2pxE2WYBpa59UcWtyzuQjJPXaMlb
 UOwictiaiP832yy3VpfZbB/Al4rAmnaqMQYvr+qYbSWHdGHyzyRZagISdnGpcP0pcLdv nA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30dn961c88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 21:32:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HLDKQI100409;
        Fri, 17 Apr 2020 21:32:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30dn928egq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 21:32:30 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03HLWSAG006990;
        Fri, 17 Apr 2020 21:32:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 14:32:27 -0700
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <ben.hutchings@codethink.co.uk>, <rfontana@redhat.com>,
        <allison@lohutok.net>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <tglx@linutronix.de>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: mvsas: remove unused symbol 'mvs_th'
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200415085053.7633-1-yanaijie@huawei.com>
Date:   Fri, 17 Apr 2020 17:32:24 -0400
In-Reply-To: <20200415085053.7633-1-yanaijie@huawei.com> (Jason Yan's message
        of "Wed, 15 Apr 2020 16:50:53 +0800")
Message-ID: <yq1v9lxn6hj.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=816
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1011
 malwarescore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=890 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170155
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> This symbol has no users so remove it.

Applied to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
