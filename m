Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434FFC433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 03:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21602613D8
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 03:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbhEGDJE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 23:09:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17128 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbhEGDJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2021 23:09:03 -0400
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210507030802epoutp014c6c11edee7e57fe4697dc7e64063bab~8qf-sXdj63014030140epoutp01k
        for <linux-scsi@vger.kernel.org>; Fri,  7 May 2021 03:08:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210507030802epoutp014c6c11edee7e57fe4697dc7e64063bab~8qf-sXdj63014030140epoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620356882;
        bh=tMDSGAXVC4BUwXo0/K/7DTop80yCWUElxEYdrjJ0eUM=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=snOia+U1VQuKJ6vWDsbqBoBCUKcGKC1LQQU8Lh2TaTI6nxhywMa1/1HcaBTywUePQ
         svD3IQxeiI8+E6bMwWiMYd0SxgjqaMFjPP44p0r+duzemsAVH/3JNqA5buoCD8auo2
         dfobW8SF7AoI8bkani5cxC/Zqtt5rw46fM+mk1Uo=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p4.samsung.com (KnoxPortal) with ESMTP id
        20210507030802epcas3p4fe3c2d9bb9ee38323891fbaee7640dcf~8qf-LzOuK0293102931epcas3p4c;
        Fri,  7 May 2021 03:08:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4FbwPG01Mcz4x9Q2; Fri,  7 May 2021 03:08:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: Re: [PATCH] scsi: ufs: remove redundant initialization of
 variable
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     Bean Huo <huobean@gmail.com>,
        Keoseong Park <keosung.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Daejun Park <daejun7.park@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <3c5dde7cd24cf10707b682cce0cac74e5ac37e9b.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2038148563.21620356881996.JavaMail.epsvc@epcpadp4>
Date:   Fri, 07 May 2021 12:05:06 +0900
X-CMS-MailID: 20210507030506epcms2p69691635624f79d6732fbf6901774878d
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210430021419epcms2p402717e968615d301ba18341d28a828ee
References: <3c5dde7cd24cf10707b682cce0cac74e5ac37e9b.camel@gmail.com>
        <2038148563.21619749381770.JavaMail.epsvc@epcpadp4>
        <CGME20210430021419epcms2p402717e968615d301ba18341d28a828ee@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

> On Fri, 2021-04-30 at 11:14 +0900, Keoseong Park wrote:
>> The variable d_lu_wb_buf_alloc may be repeatedly initialized to 0 in
>> a for-loop.
>> 
>> If the variable is set to a value other than 0, it exits the for-
>> loop, so there is no need to reset it to 0.
>> 
>> 
>> 
>> Since lun and d_lu_wb_buf_alloc are just being used in a else
>> statement inside a local scope, move the declaration of the variables
>> to that scope.
>> 
>> 
>> 
>> Signed-off-by: Keoseong Park <keosung.park@samsung.com>
> 
>UFS Spec 3.1, bDeviceMaxWriteBoosterLUs is 01h, for LU dedicated buffer
>mode, WriteBooster Buffer can be configured in only one logical unit.
> 
>Bean
> 
> 

I don't think this patch has anything to do with "bDeviceMaxWriteBoosterLUs is 01h".
If the WB LUN is 7, this patch prevents d_lu_wb_buf_alloc from being redundantly initialized 8 times.

Thanks,
Keoseong
