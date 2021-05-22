Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F69C2B9F2
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 14:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E482D61152
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 14:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhEVO6l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 10:58:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39510 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231145AbhEVO6l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 May 2021 10:58:41 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14MEX19x123816;
        Sat, 22 May 2021 10:57:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : content-transfer-encoding : mime-version; s=pp1;
 bh=Nd18HI0pDzwIu/x3CbgiB9cUq25K9reOraWIGcdZ4Kk=;
 b=fpbCCgxQ6F07EULFpeVQsLG3SBWvXkDNTFlnh0UB4gHUMSaRCZ34nRnKVt6YFfyD3jc+
 LRd9rVRVbZBckUF06K8X0+ScNMvL01iAqHsxV0966QF7lVNnn4ptQpcNa2Pi4ACpQjJD
 opduWgmWJx3WdTW79IwBWLHnrE19ZbeSTScj/IpJZeSDsVlUMOu/ot6+Gfya+pzwezRh
 3ipdmino5vHezrTTdD6AHWpzgkn7OsMtctTj+Sad7IxPdQsN4ORTiwvaMDQNsgN9v4+A
 HmTjL9QstWXVNsWXW9VoAbujsWt9wL5vuy6tgbSDhJkmgahpAFpaxL1IjSvMLeOeQlxx Pg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38q0g33ehu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 22 May 2021 10:57:02 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14MEutNZ031756;
        Sat, 22 May 2021 14:57:01 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 38psk8bjt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 22 May 2021 14:57:01 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14MEv0x924117724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 14:57:00 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 438BD7805E;
        Sat, 22 May 2021 14:57:00 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9943578063;
        Sat, 22 May 2021 14:56:58 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.80.208.94])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 22 May 2021 14:56:58 +0000 (GMT)
Message-ID: <02ff5bb3aa4894cd8ef2b0ca9d66f4c6ba34278b.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: hisi_sas: Use the correct HiSilicon copyright
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Hao Fang <fanghao11@huawei.com>, martin.petersen@oracle.com,
        john.garry@huawei.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        prime.zeng@hisilicon.com
Date:   Sat, 22 May 2021 07:56:57 -0700
In-Reply-To: <1621679075-15404-1-git-send-email-fanghao11@huawei.com>
References: <1621679075-15404-1-git-send-email-fanghao11@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8rZTdpdQsPsrYPlbTW8NdaciO1oiWpfL
X-Proofpoint-ORIG-GUID: 8rZTdpdQsPsrYPlbTW8NdaciO1oiWpfL
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-22_08:2021-05-20,2021-05-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 impostorscore=0 suspectscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=662 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105220106
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2021-05-22 at 18:24 +0800, Hao Fang wrote:
> s/Hisilicon/HiSilicon/.
> It should use capital S, according to the official website
> https://www.hisilicon.com/en.

You can't do this.  The strict terms of the GPL require us to preserve
intact all notices referring to copyright and licences.  If hisilicon
truly did make a mistake when they added their original copyright
notices, *they* may submit a patch to correct it, but you can't correct
it for them without their permission just because you think they got it
wrong.

James


