Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51F9C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiJDWrf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJDWre (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:47:34 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A3B501A5
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:47:34 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id g130so13772551pfb.8
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:47:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=yYwtOh5vG4r4D/X8p5yR2gP4bRrKguEdOtXyXDNEqKQ=;
        b=vw8wNi3oB7GrSCs3xIIEWBpwQFuPBo5P+8SWxu7FXluqMTkv684r4drm69cEasXO3w
         9REG78MKoG7Ksus/epe7lywdOK1KjWr3W4XWVr2W59SPZl7L8PyVmd9rAfYyyXMYO/gA
         5fHNXIOHBCMH0HEkoWhBDoWVk6Tr0ro/aXXKxE50nE6w83tpURNg3aq9qC01dCzFzFbs
         IZHiIQDgXtvdg75h6ItKgvxR7xorsxoGwNBL5uLrj2uXe/BUkBugbbL1CxXkyUnVRME/
         BdPro8Jtfx1xqYKs6iYs1IDwmt1VBM7uN+H09nneCrFadhK/XA/d+2IA1vVqIqIzu97e
         pd3Q==
X-Gm-Message-State: ACrzQf0ZQJecPYbqn2x672N+v9OigHFKPR+OAP6YWX9xhBM1iGwSh/wT
        XRWIwcyajxPiPwY+EkDJJLnKfBIgo3c=
X-Google-Smtp-Source: AMsMyM4qb32ThSNQjGD830SPUuBRMEQZu50H4v/AQLNul6MZVNU31Pbj2RVg0+Wvtyk0yA2axwDb/w==
X-Received: by 2002:a63:8142:0:b0:458:81d2:b29c with SMTP id t63-20020a638142000000b0045881d2b29cmr323174pgd.310.1664923653773;
        Tue, 04 Oct 2022 15:47:33 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id z3-20020a170903018300b001768452d4d7sm9462115plg.14.2022.10.04.15.47.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:47:33 -0700 (PDT)
Message-ID: <2063d871-2798-06e4-d6d0-bce1d6e32da9@acm.org>
Date:   Tue, 4 Oct 2022 15:47:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 17/35] scsi: ufshcd: Convert to scsi_exec_req
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-18-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-18-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:53, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert to scsi_exec_req so
> we pass all args in a scsi_exec_args struct.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

