Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43E3CA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 09:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC3692166E
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 09:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390231AbfJXJuf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 05:50:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52902 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725775AbfJXJuf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 05:50:35 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9O9lA0d130326
        for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2019 05:50:33 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vu6m5xy3c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2019 05:50:32 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.ibm.com>;
        Thu, 24 Oct 2019 10:50:29 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 10:50:28 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9O9oRHi62718028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 09:50:27 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11779AE058;
        Thu, 24 Oct 2019 09:50:27 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E59CEAE055;
        Thu, 24 Oct 2019 09:50:26 +0000 (GMT)
Received: from oc4120165700.ibm.com (unknown [9.152.98.184])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Oct 2019 09:50:26 +0000 (GMT)
Subject: Re: Query: SCSI Device node creation when UFS is loaded as a module
To:     asutoshd@codeaurora.org, linux-scsi@vger.kernel.org
References: <468eb805fa69da76c88a0a37aa209c7f@codeaurora.org>
From:   Steffen Maier <maier@linux.ibm.com>
Date:   Thu, 24 Oct 2019 11:50:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <468eb805fa69da76c88a0a37aa209c7f@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19102409-4275-0000-0000-00000376C266
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102409-4276-0000-0000-00003889EC0E
Message-Id: <d2804026-7908-4601-3216-e60d51131984@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240096
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/19 1:51 AM, asutoshd@codeaurora.org wrote:
> Hi
> I'm loading the ufs-qcom driver as a module but am not seeing the /dev/sda* 
> device nodes.
> Looks like it's not being created.
> 
> I find the sda nodes in other paths being enumerated though:
> 
> / # find /sys -name sda
> /sys/kernel/debug/block/sda
> /sys/class/block/sda
> /sys/devices/platform/<...>/<xxx>.ufshc/host0/target0:0:0/0:0:0:0/block/sda
> /sys/block/sda
> 
> All Luns are detected and I see sda is detected and prints for all the Luns as 
> below -:
> sd 0:0:0:0: [sda] .... ....-byte logical blocks:
> 
> ... so on ...
> 
> But if I link it statically instead of a module, it works fine. All device 
> nodes are created.
> 
> I'm trying to figure out where/how in SCSI does it create these device nodes - 
> /dev/sd<a/b/c/d> ?

That's from (systemd-)udevd user space based on uevents from the kernel.

> I've looked into sd.c but I couldn't figure out the exact place yet.

Yeah, based on the SCSI device probe and add lun, the high level driver sd 
would emit udev events for block devices.


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

