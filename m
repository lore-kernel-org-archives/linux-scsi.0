Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB6CC46467
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 22:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjASWSE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Jan 2023 17:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjASWRb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2023 17:17:31 -0500
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9117B58973
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 14:00:00 -0800 (PST)
Received: by mail-pg1-f177.google.com with SMTP id e10so2680839pgc.9
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 14:00:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k6+z3RrBrGOdhuWsw6owQDU00pyPrBlvynhUoTqUjz4=;
        b=aEHY9VFZWQNrykXQtYDlhz3eqvIRAhnj49KGkQkuDNgHzJS2W5fsn5bSRKTdifI3Rx
         dUgw5BjNXMlBXr2g/BkttracoERnGGjvoP1eJnz3NwKxw6uB2LmKnZ6QL2qxH7zzYDcm
         hDwJy59+UyUCILC5c2bKhcYhDoc8rW8vjyy2DYDcGrBTo9gw5z7XfrCqXRSWtlUn73hD
         z9Iq/4/Vr+KakzfnTCJa9Y0VxroPi301H2wK+BjJZlrm/ugTbDtsY7qe70ftqETJfy0c
         7BvoTqtd5wF7fuuuOvJxQdeBdWGP32kaCo0hKpQoFiLoajEHLVhKGuQekh09K9MbVHF0
         Dmdw==
X-Gm-Message-State: AFqh2koHsRUMh8Wf9nMbIgXYfWH1LIOWl54jh0n+x6e8uCSddmvCAA+i
        V7+C5WPK8WfTg7L39DoAFpbBfc2d1tc=
X-Google-Smtp-Source: AMrXdXtLu0shDZ2J/lHbNJVZyl9K0SYd6jTGk9O5iobNllCgwszGmhyvCJtIgAKE4Wi2qHP/qqUvgw==
X-Received: by 2002:a05:6a00:2147:b0:58d:e2b0:e480 with SMTP id o7-20020a056a00214700b0058de2b0e480mr7986455pfk.17.1674165599127;
        Thu, 19 Jan 2023 13:59:59 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:ff60:f896:307d:56f7? ([2620:15c:211:201:ff60:f896:307d:56f7])
        by smtp.gmail.com with ESMTPSA id c205-20020a624ed6000000b00580a0bb411fsm3721868pfb.174.2023.01.19.13.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 13:59:58 -0800 (PST)
Message-ID: <34076291-619f-203d-c019-7b3e303daaf2@acm.org>
Date:   Thu, 19 Jan 2023 13:59:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] Documentation: add exception capture function
Content-Language: en-US
To:     Jonathan Corbet <Corbet@lwn.net>, shijm <junming@nfschina.com>
Cc:     linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>
References: <20230115110535.5597-1-junming@nfschina.com>
 <87zgae6x30.fsf@meer.lwn.net>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <87zgae6x30.fsf@meer.lwn.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/19/23 13:20, Jonathan Corbet wrote:
> Assuming that this script is still useful, we should consider moving it
> to tools/.

I'm not sure this script has ever been used after it was added to the 
kernel tree.

Thanks,

Bart.

