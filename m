Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC075C433E3
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 13:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C573920774
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 13:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgGHNMe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 09:12:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42164 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729299AbgGHNMd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 09:12:33 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 068D24vW039729;
        Wed, 8 Jul 2020 09:12:26 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 325d2cbtde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 09:12:26 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 068DCOVK022487;
        Wed, 8 Jul 2020 13:12:24 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 322h1ga8d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 13:12:24 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 068DCLs954001720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jul 2020 13:12:21 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3302EAE04D;
        Wed,  8 Jul 2020 13:12:21 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26106AE05D;
        Wed,  8 Jul 2020 13:12:21 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.28.177])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  8 Jul 2020 13:12:21 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1jt9s3-000LlJ-U0; Wed, 08 Jul 2020 15:12:19 +0200
Date:   Wed, 8 Jul 2020 15:12:19 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        linux-s390@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        linux-doc@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        George Spelvin <lkml@sdf.org>
Subject: Re: [PATCH 0/7] zfcp: cleanups and small changes for 5.9
Message-ID: <20200708131219.GA7244@t480-pf1aa2c2>
References: <cover.1593780621.git.bblock@linux.ibm.com>
 <159418828149.5152.2055440250302680177.b4-ty@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <159418828149.5152.2055440250302680177.b4-ty@oracle.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_11:2020-07-08,2020-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 impostorscore=0 spamscore=0
 suspectscore=0 cotscore=-2147483648 adultscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007080091
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 08, 2020 at 02:06:45AM -0400, Martin K. Petersen wrote:
> On Fri, 3 Jul 2020 15:19:56 +0200, Benjamin Block wrote:
> 
> > here are some cleanups and small changes for zfcp I'd like to include in
> > 5.9 if possible.
> > 
> > One of the changes touches documentation in `Documentation/scsi/`, so I
> > put Jonathan on To, hope that was correct. I hope you can still pull
> > this all in one go to minimize work. IBM did retire some old URLs and
> > content from our public website, so we have to clean that up in the
> > documentation so there are not dead links. I changed these in the hopes
> > we can minimize documentation churn going forward, just to replace URLs.
> > 
> > [...]
> 
> Applied to 5.9/scsi-queue, thanks!
> 
> [1/7] scsi: zfcp: Use prandom_u32_max() for backoff
>       https://git.kernel.org/mkp/scsi/c/0cd0e57ec858
> [2/7] scsi: zfcp: Fix an outdated comment for zfcp_qdio_send()
>       https://git.kernel.org/mkp/scsi/c/459ad085d87b
> [3/7] scsi: docs: Update outdated link to IBM developerworks
>       https://git.kernel.org/mkp/scsi/c/b9789bfbfe9d
> [4/7] scsi: docs: Remove invalid link and update text for zfcp kernel config
>       https://git.kernel.org/mkp/scsi/c/c06de6e28c9e
> [5/7] scsi: zfcp: Clean up zfcp_erp_action_ready()
>       https://git.kernel.org/mkp/scsi/c/b43cdb5ac856
> [6/7] scsi: zfcp: Replace open-coded list move
>       https://git.kernel.org/mkp/scsi/c/6bcb7c171a0c
> [7/7] scsi: zfcp: Avoid benign overflow of the Request Queue's free-level
>       https://git.kernel.org/mkp/scsi/c/c3bfffa5ec69
> 

Thanks Martin!

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
