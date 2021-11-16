Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544B5C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 23:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19A3E61B68
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 23:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbhKPX1p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 18:27:45 -0500
Received: from mail-pj1-f41.google.com ([209.85.216.41]:33670 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhKPX1o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 18:27:44 -0500
Received: by mail-pj1-f41.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so3153971pjj.0
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 15:24:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=mjDPdu0IlEzEMkMverUlEV32YS7UAUnTO/nVUJWBxlI=;
        b=ZeDatlA/rXDmwxehM5+KxhSvpNuR3NrEGzXoufzoBq1Y0G9bn2NJYC7BrquGTg6ti4
         lBcvg0LlKJrD+Jm+ovXeq+nYJElUfuwjANGZkXRo+j7fNK4FQhTPAhkpsXQupqqt2cIS
         SCWb2EqwtuFzi/DMlGNQPI0OaOQ5R0eVIveWKwD4qGyLU8tRWzOElDg4J7iqweNaBdUy
         DWyDETWTzD2Jlr2tI82K252t11c/Z1kZBuKCGR8u/aEQN2yGK1bBBPJeG+bFQVf1Fb1t
         RDxlwylI9iMKQTzN4n2VUcb1mulT+E6LVpDIgSrwOYXd7aKW3AkIfhI9z4WlFARDD7wz
         Av1g==
X-Gm-Message-State: AOAM532KD1rildGnqcDYZvHI1I6MC65K0eO5kEEtYZnYCXAyQicak7C0
        vzjsSX+ix4GaHw3Pzs+Ja28=
X-Google-Smtp-Source: ABdhPJzV1StdKmNMqqHKEEVSMFjjldk1Z6TQQGi973ApXQ1mHYkU5lKsi6BsbctNAfGLHKwXixWvVg==
X-Received: by 2002:a17:90b:1d81:: with SMTP id pf1mr3623266pjb.79.1637105086869;
        Tue, 16 Nov 2021 15:24:46 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id s7sm2897124pfm.188.2021.11.16.15.24.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 15:24:46 -0800 (PST)
Message-ID: <652bab99-7c52-7378-792f-6b814671c0eb@acm.org>
Date:   Tue, 16 Nov 2021 15:24:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Rebasing the for-next branch
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Do you plan to rebase the for-next branch of 
git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git on v5.16-rc1? 
I just noticed that there are multiple merge conflicts between the UFS 
patch series I'm working on (based on mkp-scsi/for-next) and v5.16-rc1. 
Although rebasing is being frowned upon in the Linux kernel community, 
Linus probably will be grateful if we do the work of reducing merge 
conflicts before the v5.17-rc1 pull request is sent.

Thanks,

Bart.
