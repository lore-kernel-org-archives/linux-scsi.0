Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E7F6C0015E
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jul 2023 16:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjGQQVU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jul 2023 12:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjGQQVT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jul 2023 12:21:19 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53F21B6
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 09:21:17 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-666e3b15370so3384488b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 09:21:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689610877; x=1692202877;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PYpoGzZ4V5sfP/8mjUohMf4milpWFFjBd7JxhZylP9g=;
        b=UiqnCKJohnWzaq2YcOWL4PHRZWpa3Ue7IRCA0pe1QjGixdK0JW0jG2YPAHfd9HfWzZ
         8HUcNv/BJu2RqSlSFZ97232Wy6k+V4VG7Pv3xUZn5qfa+JgRugggoJiM99CutYGHOa0U
         6mlmBhA3K+7K34Bd6AavEkDQd8NFT9Qp2avF1UC/r/upnMX5VqXdtdHMfy8Z69luh+HZ
         dwYxduGz43em+1as0+/n0MVrlUhygsCWkbi9fBK/GQRzEkeIO12wFXCoVeY3SugPGHSc
         MEIoVzpLQx/I07maNWFft3/tVK287KoFNt7h+UN1tZBPVxMuvpKpOmrRyor9cfQlvnEW
         hd1w==
X-Gm-Message-State: ABy/qLYdoybOpVP/F+y6X70XBlb2yZejBxh4cVQ1Mre31VcEfEfEXDd6
        z+KPVnc1pEVjMeRPmzrp7wg=
X-Google-Smtp-Source: APBJJlFZaL6grIZugufN3fwdMYDEjoFHClucDJMD9UxXNf7HaCCBEWG+aj3lSfl1FEPEPZAVvKxOmg==
X-Received: by 2002:a05:6a20:728d:b0:12d:ba1e:d763 with SMTP id o13-20020a056a20728d00b0012dba1ed763mr160011pzk.7.1689610877055;
        Mon, 17 Jul 2023 09:21:17 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ac3:b183:3725:4b8f? ([2620:15c:211:201:ac3:b183:3725:4b8f])
        by smtp.gmail.com with ESMTPSA id j17-20020a170902da9100b001b9d88a4d1asm63342plx.289.2023.07.17.09.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 09:21:16 -0700 (PDT)
Message-ID: <e81bffdc-3dc0-02c1-5178-73aa787b3d2d@acm.org>
Date:   Mon, 17 Jul 2023 09:21:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v10 00/33] scsi: Allow scsi_execute users to control
 retries
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/14/23 14:33, Mike Christie wrote:
> v2:
> - Rename scsi_prep_sense
> - Change scsi_check_passthrough's loop and added some fixes
> - Modified scsi_execute* so it uses a struct to pass in args

Hi Mike,

It seems like the diffstat is missing? For large patch series it is 
convenient if a diffstat is provided.

Thanks,

Bart.

