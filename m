Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150A1C35247
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 20:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4F8C21775
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 20:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgBFUuC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 15:50:02 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45326 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbgBFUuC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 15:50:02 -0500
Received: by mail-pf1-f193.google.com with SMTP id 2so39030pfg.12
        for <linux-scsi@vger.kernel.org>; Thu, 06 Feb 2020 12:50:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KrInGoelwPgIAeVp84zS4vKZlkpZ772bLTtPxD7TgSI=;
        b=De7z+jIoL/8u7jG2sc7sw65/jNKt9zCGlLWrRRUq0Je6m+nBmm8sgHgRpU7eFy3JdF
         tQJkmAtDgXk90VIdFVsOYyiHPRlRgiVyUEqeZxn5hr64P8CODO4ZjE0VHNVQM+7dSB+0
         Txbu8yMlRxC346yB09p3TQipuEVVOUecP0XDx34roigMBiRyAVyEsHhO7+5tXHDn4RBa
         KSVVbPGrn9orbUBI6SOR5E90wL6oBtaQBWNh5FtoZdvd9fVa7IwjgiOIBB8MHFgjyOMP
         StUjrQYokTQuT0mnZRNIHEgSSGMvQYEjyHzvDDXz76l561Y4u1HL/iB4CIRLR1jeAp/p
         1nsQ==
X-Gm-Message-State: APjAAAVhRzgsqR/EmiKmLVWnWyPZXh3/c5cuY81JkPI9KG6VmYSHrQJn
        AaKlYtxbEY6ZEnP0w7IIrJQ=
X-Google-Smtp-Source: APXvYqwsKbwWdk/oXi9DyND7oki5OLfslyOujFa4mtOz20DIhy9Ap3ldlVrQF0g/YtAP6xbd9iiUXw==
X-Received: by 2002:a63:2010:: with SMTP id g16mr5998232pgg.314.1581022201613;
        Thu, 06 Feb 2020 12:50:01 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id b98sm173594pjc.16.2020.02.06.12.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 12:50:00 -0800 (PST)
Subject: Re: [PATCH 0/4] qla2xxx patches for kernel v5.6
To:     Martin Wilck <mwilck@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, "dwagner@suse.de" <dwagner@suse.de>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <bb273446a0f294e37dc0afb2c450fb761e345260.camel@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <559ee60f-43e8-b228-f14b-7453d62e7780@acm.org>
Date:   Thu, 6 Feb 2020 12:49:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <bb273446a0f294e37dc0afb2c450fb761e345260.camel@suse.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/6/20 5:23 AM, Martin Wilck wrote:
> Hi Bart, hi Martin,
> 
> On Mon, 2019-12-09 at 10:02 -0800, Bart Van Assche wrote:
>> Hi Martin,
>>
>> Please consider these four small qla2xxx patches for kernel v5.6.
>>
>> Thanks,
>>
>> Bart.
> 
> it seems this series got lost somehow, including the point-to-point
> mode fix?
> 
> I made some remarks back in December, but they were mostly nitpicks.
> The only real issue with this set is that the last patch doesn't apply
> cleanly.

Hi Martin,

The first patch of this series has been queued by Martin Petersen for 
the v5.7 merge window. I plan to repost patches 2/4 and 4/4 of this 
series after the merge window has closed. Patch 3/4 (the fix for 
point-to-point mode) has been dropped because I'm not confident that my 
fix is a proper fix.

Thanks,

Bart.
