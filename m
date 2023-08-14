Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E24C001E0
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 17:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjHNRQd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 13:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjHNRQI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 13:16:08 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D099110CE;
        Mon, 14 Aug 2023 10:15:55 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6884310ee75so514208b3a.1;
        Mon, 14 Aug 2023 10:15:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692033355; x=1692638155;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=378EDEP8qjs0UlKYUb4acq3gHymwhtNVGzwjLOHLT4c=;
        b=Oiy+pbKDOXvRjUiyCkON0nNTAsOS7v0c/wz+5TTecrOH39MGcbtNi55kVtV4mEKpKf
         G+On8UDI6lKVUg0d8qk4I71YOVcJCD+47imtjP5RPSquS10m9CmBVJbbvVvDyrXqsJ++
         6PEsGFJbi3LGeDfaNwy82WlBfBW+nJ5ukLL5Flk0mmpGZDUjPDO5T8qscGVrnzPJOF5B
         xfSxz3hgpIzKQk0Flo9ofEg61XzTknQEmSafIREOGvFan6WCR/YukAO5iPnrWspxUyfN
         ye90IkBsJGaSnnXaGhFGfPX2kxuKlEi802m4s4ohgGWkadeUKVaDuAxajjM9II2cIqWZ
         gzBA==
X-Gm-Message-State: AOJu0Yz/bdhSqAVtBYt7QqbDQyBVaJywxwlAp4b3dJm9PmEkyP2hlt1P
        riUPK6cl9wK5YF9WY5lwkUVAasfJEXw=
X-Google-Smtp-Source: AGHT+IEIUE1KFAs9fF/gI0b1AfBUod37acKWdthN7e03Gp4JsKLH/6+A24M4a2LnOv06ajNZJRq8Qw==
X-Received: by 2002:a17:90a:d798:b0:267:f1d0:ca70 with SMTP id z24-20020a17090ad79800b00267f1d0ca70mr9221057pju.47.1692033355189;
        Mon, 14 Aug 2023 10:15:55 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e105:59a6:229c:65de? ([2620:15c:211:201:e105:59a6:229c:65de])
        by smtp.gmail.com with ESMTPSA id gf12-20020a17090ac7cc00b0026961746a8fsm2571244pjb.27.2023.08.14.10.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 10:15:54 -0700 (PDT)
Message-ID: <efa818c5-fb7d-7338-9ba8-9a7e8fd89085@acm.org>
Date:   Mon, 14 Aug 2023 10:15:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH] scsi: core: Use 32-bit hostnum in scsi_host_lookup()
Content-Language: en-US
To:     Tony Battersby <tonyb@cybernetics.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <a02497e7-c12b-ef15-47fc-3f0a0b00ffce@cybernetics.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a02497e7-c12b-ef15-47fc-3f0a0b00ffce@cybernetics.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/23 07:03, Tony Battersby wrote:
> Change scsi_host_lookup() hostnum argument type from unsigned
> short to unsigned int to match the type used everywhere else.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
