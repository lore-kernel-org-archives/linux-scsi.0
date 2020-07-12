Return-Path: <SRS0=csMy=AX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A318C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 18:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6543206E2
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 18:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgGLSnM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jul 2020 14:43:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32624 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727966AbgGLSnM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Jul 2020 14:43:12 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06CIWIFv177550;
        Sun, 12 Jul 2020 14:43:04 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3279x7df14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Jul 2020 14:43:04 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06CIYQqO024757;
        Sun, 12 Jul 2020 18:43:03 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01dal.us.ibm.com with ESMTP id 32752859pd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Jul 2020 18:43:03 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06CIgxBs28246510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 12 Jul 2020 18:42:59 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 696D07805C;
        Sun, 12 Jul 2020 18:43:02 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4971D78063;
        Sun, 12 Jul 2020 18:43:01 +0000 (GMT)
Received: from [153.66.254.194] (unknown [9.85.141.100])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun, 12 Jul 2020 18:43:00 +0000 (GMT)
Message-ID: <1594579379.3446.23.camel@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] scsi_debug: update documentation url and bump
 version
From:   James Bottomley <jejb@linux.vnet.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de
Date:   Sun, 12 Jul 2020 11:42:59 -0700
In-Reply-To: <20200712182927.72044-3-dgilbert@interlog.com>
References: <20200712182927.72044-1-dgilbert@interlog.com>
         <20200712182927.72044-3-dgilbert@interlog.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-12_09:2020-07-10,2020-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=621 mlxscore=0 priorityscore=1501
 phishscore=0 malwarescore=0 clxscore=1011 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007120144
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2020-07-12 at 14:29 -0400, Douglas Gilbert wrote:
[...]
> - *  For documentation see http://sg.danny.cz/sg/sdebug26.html
> + *  For documentation see http://sg.danny.cz/sg/scsi_debug.html

If you're doing this, what about asking danny for a https URL to at
least prevent pointless churn around this file?

James

