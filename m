Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F281C31E40
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CAAC206A2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfHLOi6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 10:38:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21426 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726817AbfHLOi6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Aug 2019 10:38:58 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CEWB8Y038480;
        Mon, 12 Aug 2019 10:35:13 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ub9afhxwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 10:35:13 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7CETp5C021839;
        Mon, 12 Aug 2019 14:35:12 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 2u9nj6fes0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 14:35:12 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7CEZAOX58655116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 14:35:10 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D478D6E056;
        Mon, 12 Aug 2019 14:35:10 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7802B6E050;
        Mon, 12 Aug 2019 14:35:09 +0000 (GMT)
Received: from jarvis.ext.hansenpartnership.com (unknown [9.80.199.198])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 12 Aug 2019 14:35:09 +0000 (GMT)
Message-ID: <1565620508.3422.6.camel@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 07/20] sg: move header to uapi section
From:   James Bottomley <jejb@linux.vnet.ibm.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        hare@suse.de, bvanassche@acm.org, linux-spdx@vger.kernel.org
Date:   Mon, 12 Aug 2019 07:35:08 -0700
In-Reply-To: <20190812142451.GG8105@infradead.org>
References: <20190807114252.2565-1-dgilbert@interlog.com>
         <20190807114252.2565-8-dgilbert@interlog.com>
         <20190812142451.GG8105@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120163
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2019-08-12 at 07:24 -0700, Christoph Hellwig wrote:
> [note: question for the linux-spdx audience below]
> 
> > -
> >  #ifdef __KERNEL__
> >  extern int sg_big_buff; /* for sysctl */
> >  #endif
> 
> FYI, these __KERNEL__ ifdefs in non-uapi headers should go away.
> 
> >  
> > +/*
> > + * In version 3.9.01 of the sg driver, this file was spilt in two,
> > with the
> > + * bulk of the user space interface being placed in the file being
> > included
> > + * in the following line.
> > + */
> > +#include <uapi/scsi/sg.h>
> 
> Splitting uapi headers is standard practive, no need for the comment,
> especially not with a meaningless driver version number.
> 
> > diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
> > new file mode 100644
> > index 000000000000..072b45bd732f
> > --- /dev/null
> > +++ b/include/uapi/scsi/sg.h
> > @@ -0,0 +1,329 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> 
> This needs the syscall noticed for uapi headers.  FYI, what is our
> stance of just adding that notice to headers newly moved to UAPI?
> Do we need agreement from everyone who touched the file?  Or just
> after we started the split and SPDX annotations, as in this case
> this header used to be available to user programs?

It's pretty much covered by the original linux COPYING file, which
contains the systemcall exception for everything.  I think our
intention is that this still applies globally, so things can be moved
into the UAPI without additional permissions.

James

