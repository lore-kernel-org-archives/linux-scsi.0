Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF00C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 20:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 390782084B
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 20:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfKZU5k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 15:57:40 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43023 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfKZU5k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 15:57:40 -0500
Received: by mail-pg1-f194.google.com with SMTP id b1so9589063pgq.10;
        Tue, 26 Nov 2019 12:57:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r0S0arZ17+FJgM/rUvMmj5gqLzSZZABsLg0tsFcbNlA=;
        b=IvQV619XOm2IhNYU/1aGqs8nbMVqxmsuI5YrK0eUWUsoyqlGR/tlxPyyPpP++nkA4f
         pedcHJYhp2sPKmXBgahctEcgBbQ5kkhyiH0WdRnSbiibMP+sa7yg2ZlAZwMrRO6UFO8i
         hDSIx3NPGi1ltxHBW7spBNKba2KAb9tPB8FEJzMNngtRvJluKbHtuWsoE99MNKUayNhZ
         tysZDwPr9QhXiUo2PeQCU+eRCGcJQpfcnbCUtUg9lfhUSaBcHZLOomJpPSO/LsrG3Ulj
         rnNeO6/xjYiLp3zV0UtMKX1r85jvanTUR3EIEuihap01aTXRNb40973uY9SaQIKOMpYW
         TDUw==
X-Gm-Message-State: APjAAAU2qCcK64dwPXQj+uuWUVvp+AoSIi+WJxkbmm9rxefSdXzDuiOU
        /TIGz8TWj7863F+Y2NDPhOI=
X-Google-Smtp-Source: APXvYqwC141moLT1tDBGB9wQdG7dNn7iL3yo7qkEWBBtCssT2HCX+lMOdgRww7pSP1GLcu3yGHrMtg==
X-Received: by 2002:a63:c80e:: with SMTP id z14mr561281pgg.240.1574801859759;
        Tue, 26 Nov 2019 12:57:39 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id y6sm12837936pfm.12.2019.11.26.12.57.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 12:57:39 -0800 (PST)
Subject: Re: [PATCH v3 13/13] scsi: qla2xxx: Add debug dump of LOGO payload
 and ELS IOCB
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     linux@yadro.com, Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>, Hannes Reinecke <hare@suse.de>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
 <20191125165702.1013-14-r.bolshakov@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ee7b7512-8f47-15e5-b6a5-29914b1c4c00@acm.org>
Date:   Tue, 26 Nov 2019 12:57:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191125165702.1013-14-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/19 8:57 AM, Roman Bolshakov wrote:
> The change adds a way to debug LOGO ELS, likewise PLOGI.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

