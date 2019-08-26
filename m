Return-Path: <SRS0=IeCF=WW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6675CC3A59E
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 08:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 449752173E
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 08:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbfHZIdQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Aug 2019 04:33:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29890 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbfHZIdP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Aug 2019 04:33:15 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7Q8Wqd8131575;
        Mon, 26 Aug 2019 04:33:10 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2um9mb5bgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Aug 2019 04:33:09 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7Q8X5r5132260;
        Mon, 26 Aug 2019 04:33:08 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2um9mb5ajr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Aug 2019 04:33:00 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7Q8U2o3009495;
        Mon, 26 Aug 2019 08:31:52 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04dal.us.ibm.com with ESMTP id 2ujvv6eqwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Aug 2019 08:31:52 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7Q8VpR727197824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 08:31:51 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96A99AC05B;
        Mon, 26 Aug 2019 08:31:51 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84A19AC059;
        Mon, 26 Aug 2019 08:31:49 +0000 (GMT)
Received: from jarvis.ext.hansenpartnership.com (unknown [9.85.160.207])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 26 Aug 2019 08:31:49 +0000 (GMT)
Message-ID: <1566808307.3089.2.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: aic7xxx: Remove dead code
From:   James Bottomley <jejb@linux.ibm.com>
To:     Souptick Joarder <jrdr.linux@gmail.com>, hare@suse.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 26 Aug 2019 09:31:47 +0100
In-Reply-To: <1566659302-3514-1-git-send-email-jrdr.linux@gmail.com>
References: <1566659302-3514-1-git-send-email-jrdr.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-26_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908260095
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2019-08-24 at 20:38 +0530, Souptick Joarder wrote:
> These are dead code since 2.6.13. If there is no plan
> to use it further, these can be removed forever.

Unless you can articulate a clear useful reason for the removal I'd
rather keep this and the other code.  Most of the documentation for
this chip is lost in the mists of time, so code fragments like this are
the only way we know how it was supposed to work.

A clear reason might be that it's impossible for aic7xxx ever to make
use of IU and QAS because they're LVD parameters and it's a SE/HVD
card, so the documentation in the code is actively wrong, but you'd
need to research that.

James

