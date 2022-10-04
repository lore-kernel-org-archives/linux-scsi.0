Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 648A8C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiJDWrD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJDWrC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:47:02 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454C0501A5
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:47:02 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id 67so85375pfz.12
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:47:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=yYwtOh5vG4r4D/X8p5yR2gP4bRrKguEdOtXyXDNEqKQ=;
        b=FoZcaODcKHswdjUJ1PPo2+O24lBFSKjgxNmLLR018KXKGNevVq6rcUtEiIphW0KOKi
         CHf12Yex0ICqH5pMt4U1GdsV3KzGqNw/VeTeB0rRNNl9b3EN0+CTcUs23NNHd1qugbn+
         YRJRocMPuoGd3AVLsoR/iJ+c8co52x5iwsyEZC0QPh6swb2D9d+HrG7aCRthlxkQ4RxJ
         KzMqkWJwCNZwroj8UvRRHfive3ADZwKqjffKzEqxHHZ2R4wzY4kLMDyEpLp0oIOndFdI
         sqjpMGcKXoMZDdmWAyUUT5a0Y69+SbZOgmvI3IlwK+a1amEbNdSenMSAg9pTedYMrjRY
         eS0Q==
X-Gm-Message-State: ACrzQf0UeGP/1baJQJPAO7gY7nj/o/jgh+/ZrdX+bq2MRqDS8YQQEWnB
        TQ5WqAaZnYd6fevzZ5czCmg=
X-Google-Smtp-Source: AMsMyM5K1e4Grcecd5Nx+PUWPunC5b4eU6fpuuJePB8xO16Pg+m+jvBUIBmMToTEwUIkTNqVNODF4w==
X-Received: by 2002:a63:6c07:0:b0:457:523c:4bd0 with SMTP id h7-20020a636c07000000b00457523c4bd0mr2273407pgc.101.1664923621630;
        Tue, 04 Oct 2022 15:47:01 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id y23-20020a63de57000000b00440416463fesm8965609pgi.27.2022.10.04.15.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:47:00 -0700 (PDT)
Message-ID: <cd926135-a7b2-54b3-ef87-970ad25cc274@acm.org>
Date:   Tue, 4 Oct 2022 15:46:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 16/35] scsi: target_core_pscsi: Convert to
 scsi_exec_req
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-17-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-17-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:53, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert to scsi_exec_req so
> we pass all args in a scsi_exec_args struct.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
