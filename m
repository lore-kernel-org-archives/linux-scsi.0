Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECB5C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 02:56:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D05B764E0F
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 02:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhCACzp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 21:55:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46792 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231890AbhCACzl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 28 Feb 2021 21:55:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614567255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1j+xD5RJ8GQs46x6EyImDPRxYUCzKqNINBOTAQCWMcs=;
        b=hPT79uFz+THlZGXc1lFTKGsSCoyjThbgXjQ4diktSLmMulY9a3mOumPkZp5iKVpAOVeILb
        2+iKlGqySf6imVgn+LqDJEWrkHBY0SbIv18iZ5CVnZ2bJ45yqPfEeOSWoczm0SQPBic9I/
        JCs0RtT+WhzY9A+2w2aA6w79/fIo+Y4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-Qrs-sLJUPxetI8FXZMIZ7g-1; Sun, 28 Feb 2021 21:54:12 -0500
X-MC-Unique: Qrs-sLJUPxetI8FXZMIZ7g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43117C289;
        Mon,  1 Mar 2021 02:54:11 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-126.pek2.redhat.com [10.72.12.126])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 316F660BFA;
        Mon,  1 Mar 2021 02:54:08 +0000 (UTC)
Subject: Re: [bug report]null pointer at scsi_mq_exit_request+0x14 with
 blktests srp/015
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
References: <418155251.14154941.1614505772200.JavaMail.zimbra@redhat.com>
 <BYAPR04MB4965FDA9847096508E35FFB9869B9@BYAPR04MB4965.namprd04.prod.outlook.com>
From:   Yi Zhang <yi.zhang@redhat.com>
Message-ID: <4ab0ac23-ad15-748d-7101-a1f964f338a9@redhat.com>
Date:   Mon, 1 Mar 2021 10:54:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB4965FDA9847096508E35FFB9869B9@BYAPR04MB4965.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sure, will do.

On 3/1/21 3:07 AM, Chaitanya Kulkarni wrote:
> On 2/28/21 01:52, Yi Zhang wrote:
>> Hello
>>
>> I found this issue with blktests srp/015, could anyone help check it?
> Until you get some reply you can try and bisect it.
>
>

