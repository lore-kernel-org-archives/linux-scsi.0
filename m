Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FAAAC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 18:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5159E6503E
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 18:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240160AbhCPSrw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 14:47:52 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:36712 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237388AbhCPSrm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 14:47:42 -0400
Received: by mail-pl1-f178.google.com with SMTP id z5so17395937plg.3;
        Tue, 16 Mar 2021 11:47:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=khK434BIiQNbKwZtzyumZPF2IE6clGJ/tsZsrY76bxI=;
        b=aNKef6ohhMsOqcLzlCn5toweArCxBoZe8MOSv72+oyFWyNbkQb+Vy7HzxguwVA4fhb
         3coCfbS5FBPes1hb8FAcNSijk5QQH+qVr7DLVAIzXtDdifZiT1IdSrgPan6I1Q2erlt/
         +/vRuypU+rIfhPC50mXkz857VLmh9/xf1Lx/afbh5nbR30fiWEbyhZlaGy+Nmpgg+c6U
         WgqKtw7Jfz0uXTJOHtLyFiKhtz1kpgJjYYaps8fKca5JAV2rCLpE2rNbIJgYZPAtUDpZ
         mL7ICm/WBqyjYCjN2NNoRT/NHtoyXMZ/m2lM6M9RvdFGBU8sR/Ad9Y6ODoXGGSGyFnJf
         qxkQ==
X-Gm-Message-State: AOAM533HiPg64T98Foo6Z0T7ktqJwFVa8oVH9WTFJyDcrQ6E4/daFld7
        bcPFhjwas5+fFnhoCFwtmXc=
X-Google-Smtp-Source: ABdhPJyZLqIoq5Qop3XTp/fH685REdLwLmOwKMy9VQ3jzbgB19+wldT2AmmvNn+KVy5DqsGPDQe/zA==
X-Received: by 2002:a17:902:b711:b029:e6:be1a:5510 with SMTP id d17-20020a170902b711b02900e6be1a5510mr692279pls.77.1615920461484;
        Tue, 16 Mar 2021 11:47:41 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id r23sm139176pje.38.2021.03.16.11.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 11:47:40 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 6F4A740244; Tue, 16 Mar 2021 18:47:39 +0000 (UTC)
Date:   Tue, 16 Mar 2021 18:47:39 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-block@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: blktests: block/009 next-20210304 failure rate average of 1/448
Message-ID: <20210316184739.GJ4332@42.do-not-panic.com>
References: <20210316174645.GI4332@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316174645.GI4332@42.do-not-panic.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 16, 2021 at 05:46:45PM +0000, Luis Chamberlain wrote:
> I've managed to reproduce blktests block/009 failures with kdevops [0]
> on linux-next tag next-20210304 with a current failure rate average of
> 1/448 (3 counted failures so far).

Confirmed on next-20210316 with current failure rate at 1/1008

  Luis
