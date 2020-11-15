Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66D6C63697
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 16:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C41E2344C
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 16:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgKOQEM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 11:04:12 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:55651 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgKOQEM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 11:04:12 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 4947A2EA0F4;
        Sun, 15 Nov 2020 11:04:11 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id PbKEBD4BdeXs; Sun, 15 Nov 2020 10:54:54 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id E49552EA0F6;
        Sun, 15 Nov 2020 11:04:10 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v1 3/3] scsi_debug: iouring iopoll support
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20201015133721.63476-1-kashyap.desai@broadcom.com>
 <10349873a8c9adfc95fec50e0152f807@mail.gmail.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <9b4222bc-5e25-12e1-7ad2-e1eee44b3c34@interlog.com>
Date:   Sun, 15 Nov 2020 11:04:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <10349873a8c9adfc95fec50e0152f807@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-13 5:50 a.m., Kashyap Desai wrote:
>> -----Original Message-----
>> From: Kashyap Desai [mailto:kashyap.desai@broadcom.com]
>> Sent: Thursday, October 15, 2020 7:07 PM
>> To: linux-scsi@vger.kernel.org
>> Cc: Kashyap Desai <kashyap.desai@broadcom.com>; dgilbert@interlog.com;
>> linux-block@vger.kernel.org
>> Subject: [PATCH v1 3/3] scsi_debug: iouring iopoll support
>>
>> Add support of iouring iopoll interface in scsi_debug.
>> This feature requires shared hosttag support in kernel and driver.
>>
>> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
>> Cc: dgilbert@interlog.com
>> Cc: linux-block@vger.kernel.org
>> ---
>>   drivers/scsi/scsi_debug.c | 123 ++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 123 insertions(+)
> 
> 
> Hi Doug - Any comment/feedback ?

Hi,
I'm testing this patch and have found an issue which I have taken up
directly with Kashyap. More to follow.

Doug Gilbert

