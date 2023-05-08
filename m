Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544A8C77B75
	for <linux-scsi@archiver.kernel.org>; Mon,  8 May 2023 14:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbjEHOJK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 May 2023 10:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234122AbjEHOJH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2023 10:09:07 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E295B123
        for <linux-scsi@vger.kernel.org>; Mon,  8 May 2023 07:09:06 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-52160f75920so3035177a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 08 May 2023 07:09:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683554946; x=1686146946;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KS8qMMjKzs4AfHIwaMmcZRDZzsLgQ06bGlnM4LkxNkU=;
        b=iLuiRiu+sUPUno5z6fx3kN8SpD0OcR8zj1TRXMQ+6RRP3dqzeEVzte8ozvD3oQ+mYr
         Ist+WJ29zxRk5ucgOOCnxbW0ncaRqPkCzmIRq/fmHNHdSigJVOnkuqbiiw3qEbFW0Bmr
         c+0fm5fiOkbxuJ6P6Zt+1X5CLQGGbq9ZaJjMEXMTt1rd7jqb0iJeNlrnf2mpXhv5KCHw
         ldiyl80wT6Nro+l4cjGlinC7UuMluErbBN+v2iJVOj63zE84DgoXg924iGgfU1llRJS6
         d1KllkgbPkZ48TMrHTofMROJgjfR89wLoOfwA7rJt4hUhWiDTHCwK8iERhkgy3W5wxgR
         wDfw==
X-Gm-Message-State: AC+VfDz4rvWUv2HcSGylemXDUIeCAbfDVy6pqyaUxUVWYSx9fl83+NQl
        NJfiRh/ciCcf2hs9zSYQGvU=
X-Google-Smtp-Source: ACHHUZ55Y9YasnOT+vAxSVYhS0nXevtpzOjlZOXZjtiqkIAPOrFIRSTk+zgVoQzWTiaHxyLfhTpZDA==
X-Received: by 2002:a05:6a20:3952:b0:f0:a556:4777 with SMTP id r18-20020a056a20395200b000f0a5564777mr14285729pzg.3.1683554946200;
        Mon, 08 May 2023 07:09:06 -0700 (PDT)
Received: from [172.20.11.151] ([173.214.130.133])
        by smtp.gmail.com with ESMTPSA id a16-20020a62e210000000b006439df7ed5fsm41622pfi.6.2023.05.08.07.09.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 07:09:05 -0700 (PDT)
Message-ID: <4e27d8b5-9327-0d2f-4984-c3678ec740fc@acm.org>
Date:   Mon, 8 May 2023 07:09:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 2/5] scsi: core: Update a source code comment
Content-Language: en-US
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230503230654.2441121-1-bvanassche@acm.org>
 <20230503230654.2441121-3-bvanassche@acm.org>
 <20230508112550.GC9720@t480-pf1aa2c2.fritz.box>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230508112550.GC9720@t480-pf1aa2c2.fritz.box>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/8/23 04:25, Benjamin Block wrote:
> On Wed, May 03, 2023 at 04:06:51PM -0700, Bart Van Assche wrote:
>> The proc_name SCSI host template attribute is used for:
>> - The name of the /proc directory if CONFIG_SCSI_PROC_FS=y.
> 
> But now you remove that case completely? It seems kinda strange to
> bother touching the comment, but then only switching from one incomplete
> form to an other?

Using procfs as an interface to other information than process information
is deprecated, so I'm not sure it's worth mentioning how this name is used
if CONFIG_SCSI_PROC_FS=y.

Bart.
