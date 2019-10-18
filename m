Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C5ECA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 10:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8F84222C9
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 10:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408241AbfJRKfw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 06:35:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31298 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729479AbfJRKft (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 06:35:49 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9IARhkS076004
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 06:35:47 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vqbgxgkf7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 06:35:47 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Fri, 18 Oct 2019 11:35:45 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 18 Oct 2019 11:35:43 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9IAZACY37290384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 10:35:10 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 797F842041;
        Fri, 18 Oct 2019 10:35:42 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A5C04203F;
        Fri, 18 Oct 2019 10:35:42 +0000 (GMT)
Received: from osiris (unknown [9.152.212.85])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 18 Oct 2019 10:35:42 +0000 (GMT)
Date:   Fri, 18 Oct 2019 12:35:40 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steffen Maier <maier@linux.ibm.com>
Subject: Re: [GIT PULL] SCSI fixes for 5.4-rc3
References: <1571166922.15362.19.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571166922.15362.19.camel@HansenPartnership.com>
X-TM-AS-GCONF: 00
x-cbid: 19101810-4275-0000-0000-0000037345A6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101810-4276-0000-0000-00003886617A
Message-Id: <20191018103540.GC3885@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-18_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=725 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910180102
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 15, 2019 at 03:15:22PM -0400, James Bottomley wrote:
> Five changes, two in drivers (qla2xxx, zfcp), one to MAINTAINERS
> (qla2xxx) and two in the core.  The last two are mostly about removing
> incorrect messages from the kernel log: the resid message is definitely
> wrong and the sync cache on protected drive problem is arguably wrong.
> 
> The patch is available here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
> 
> The short changelog is:
> 
> Damien Le Moal (1):
>       scsi: core: save/restore command resid for error handling
> 
> Daniel Wagner (1):
>       scsi: qla2xxx: Remove WARN_ON_ONCE in qla2x00_status_cont_entry()
> 
> Himanshu Madhani (1):
>       scsi: MAINTAINERS: Update qla2xxx driver
> 
> Oliver Neukum (1):
>       scsi: sd: Ignore a failure to sync cache due to lack of authorization
> 
> Steffen Maier (1):
>       scsi: zfcp: fix reaction on bit error threshold notification

James, Martin, I do not know how you coordinate your work, however is
there any chance that the two fixes sitting in

https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=postmerge

get merged anytime soon?

6b6fa7a5c86e1269d9f0c9a5b902072351317387 ("scsi: core: fix dh and multipathing for SCSI hosts without request batching")
82a9ac7130cf51c2640800fb0ef19d3a05cb8fff ("scsi: core: fix missing .cleanup_rq for SCSI hosts without request batching")

I have a CI system which fails to boot since two weeks because of this...

