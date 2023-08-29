Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 942DEC83F12
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Aug 2023 17:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237235AbjH2RHx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 13:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237611AbjH2RHW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 13:07:22 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC79AD
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 10:07:20 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1bf7a6509deso24143915ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 10:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693328839; x=1693933639;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KjLjlOoM3U7ufc084yNH6TsVvgqYkEghyhOyk5lfcBI=;
        b=VttpJEu3RZEcx6SzvmNGkFKakpuVNg9zkV/jZg9Y8TxZEHZ6chWI2KcJLT4Hw8+S8p
         UAhRO0wRiZNlqn1t89SMYR76mvxxq7e9amGkogXZGL8670s1Qr7wqarc31SKL2DdZn83
         FaBRGeI9rerYaUjlZVuoNox+DsFuMRiTpJNckIPtHrfllgyS5ltE9o1iNs7R5vzQ8xNH
         Gr9GMH/2+zAxofZHiPATsjHMMyqCNXTla3SL3p2bKvT3Cu7Thu14VANtxolsB6qx6iT/
         dNtXbJ0DLHvgqd4fFGJn8Nq3I7bUEwEFArsjpD/DxK9CmvPLi+T6EjXktJ8Re7vHbMKt
         p8Pg==
X-Gm-Message-State: AOJu0Yy8al1ROTku8LnDY8x7zVfGnivofL7OlyhivW926LqINuN706C3
        RN+26pzkvTY2m5WIXyac+xI=
X-Google-Smtp-Source: AGHT+IEf9JRdhde0NpVHWh/jMcgw/6waXQCMJHJCnTw1/Y8ifCZ1+YzbGmhjKtuTM0c52SIkVlgmVQ==
X-Received: by 2002:a17:902:6b0c:b0:1c0:e6e1:4a11 with SMTP id o12-20020a1709026b0c00b001c0e6e14a11mr6784755plk.54.1693328839525;
        Tue, 29 Aug 2023 10:07:19 -0700 (PDT)
Received: from [172.20.4.71] ([208.98.210.70])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902e54a00b001bf5e24b2a8sm9595806plf.174.2023.08.29.10.07.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 10:07:18 -0700 (PDT)
Message-ID: <3aac6dcc-cf5e-4e22-8c0d-aa408667a746@acm.org>
Date:   Tue, 29 Aug 2023 10:07:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/3] Fix abnormal clock scaling behaviors
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com
References: <20230823092948.22734-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230823092948.22734-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/23/23 02:29, peter.wang@mediatek.com wrote:
> This patch fix abnormal clock scaling behaviors.

For a reason that is not known to me this patch series did not show up 
in my mailbox. I have imported these patches manually from lore into my
mailbox.

Bart.
