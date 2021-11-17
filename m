Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8E8C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 05:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5673619E3
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 05:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhKQFJP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 00:09:15 -0500
Received: from mail-pl1-f179.google.com ([209.85.214.179]:38575 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhKQFJP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 00:09:15 -0500
Received: by mail-pl1-f179.google.com with SMTP id o14so1106556plg.5
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 21:06:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9lwKFazQ6G5LS0TZo/VrRi1lrR/Uvr51kovE8KL9KGw=;
        b=vDn1f7646H74r0o17Zmo0EL1OSg+BCIiCpMlEfCIGv7ehODKQrS66ZHUfJXQiJPEdC
         SAH3hg3G55eMhONdpkbO/q4ZreXWGOpQ6v91kwL/ab95TUnofAFlwe1j+Ak4R5eiPkcx
         7ai5/7xtDF0I/tqMz1mXZ5wd7h6wsXPyDdBqnNi/AmWVvs41pL2OFT/xzu4Vp4EK9gNA
         XXn6ti/hMT16gWEIsEERCYB+2UyNSJlH/za4l8H8RQFdI7fGm1eE91enbKoqv7UwTLzo
         sSo8r7x1TXl/MqBHlbfXi96FY0VuzxbQiTq5j3190s8W/19BK2oFDgnAl1NfyRYntqDk
         Vx0g==
X-Gm-Message-State: AOAM531DkWVyZjQAxEqsMpunQW1+Po4pJH3b2nMbuk0uJmpz5Tm8c++q
        KLPgkefQU1Y9g6DZB5XdvtQ=
X-Google-Smtp-Source: ABdhPJwTyPzK5SUJ3Ur+dE/rzM72IXcBIFjl6tWhxS1JPPsT9dv5BLPANfPaFdAwkRCZSXayqCMIMw==
X-Received: by 2002:a17:90a:3b02:: with SMTP id d2mr5690814pjc.159.1637125577391;
        Tue, 16 Nov 2021 21:06:17 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id f1sm21394335pfj.184.2021.11.16.21.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 21:06:16 -0800 (PST)
Subject: Re: [PATCH 01/15] libsas: Don't always drain event workqueue for HA
 resume
From:   Bart Van Assche <bvanassche@acm.org>
To:     chenxiang <chenxiang66@hisilicon.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linuxarm@huawei.com,
        john.garry@huawei.com
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-2-git-send-email-chenxiang66@hisilicon.com>
 <91972e78-78cc-2b38-f730-a26a8a1b607c@acm.org>
Message-ID: <af98a24a-60ec-4cd0-e676-6d1f4e75b938@acm.org>
Date:   Tue, 16 Nov 2021 21:06:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <91972e78-78cc-2b38-f730-a26a8a1b607c@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/21 8:14 PM, Bart Van Assche wrote:
> On 11/16/21 18:44, chenxiang wrote:
>> [ ... ]
> 
> Where is the cover letter of this patch series? Please always
> include a cover letter with a patch series.

Oops, I was too fast. Patches 01/15..15/15 arrived in my mailbox before the cover
letter. I just received the cover letter.

Thanks,

Bart.
