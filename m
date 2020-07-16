Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD3BC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 00:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2C462071B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 00:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgGPAGp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 20:06:45 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43850 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgGPAGp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 20:06:45 -0400
Received: by mail-pl1-f195.google.com with SMTP id x8so3068850plm.10
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 17:06:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6hstUTN+dzsWN4v+Y1/ZILmFhM55ptpmRwlsWFtPUg0=;
        b=L62NW/ZGBb0kJJXD4cIgCRJlDueeNF+EdZD4Iz2gSa1ONuRzilViRYP5bqsL2F4Mno
         dnGHKpS9PjzfyKoVH5GBWxeAi1FmCwmCRiGC6hZuUevOhChOUdcOjbhqouiMH8g8mrqd
         oJvlRtL0JSZJcWN4TCwXsW93YZFIQA9hFxROHypqZH3yPvi8jKGpQA0vdlnKGdGfpfyY
         8oPqLwah6GQURxCt47ENM58YEKyuP8cTzAzQHkqKBhggLcCppPHrCvq7bMV+TZf4YmpM
         n9BqMGwUu69hPpePzShOndQkzL6jVFylRjupjB7jbr8MlGqGcsxzENy4ilLlvWCgja/k
         gw7A==
X-Gm-Message-State: AOAM533xxqKOGVPDk65xVptXYx53fD+p+mKqi57WRmInd1q/aQ4EotqH
        XdlPUcWdTYOX2rmm/CCuOAAq0sP0
X-Google-Smtp-Source: ABdhPJy4jj63IHjI/NSGKVNRG9Jq0XimULgadVZgZw/XY36FjkvBPK467LBNOwPyUUSOCm8R96Rhow==
X-Received: by 2002:a17:902:7688:: with SMTP id m8mr1577147pll.12.1594858003934;
        Wed, 15 Jul 2020 17:06:43 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w17sm3134233pge.10.2020.07.15.17.06.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 17:06:43 -0700 (PDT)
Subject: Re: LIO Scsi Target
To:     Lee Duncan <lduncan@suse.com>,
        Sadegh Ali <sadegh.ali.2084@gmail.com>,
        linux-scsi@vger.kernel.org
References: <CA+RHgKLt=ZOu_nnL6oX=LJVtJWE9i+ARE6A_VmGLeJaU1mYtSg@mail.gmail.com>
 <43b31e85-9d9c-c3ef-a008-83510a968ee7@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <416369e6-236e-7c15-48f0-5e7045501397@acm.org>
Date:   Wed, 15 Jul 2020 17:06:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <43b31e85-9d9c-c3ef-a008-83510a968ee7@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-15 11:16, Lee Duncan wrote:
> SCST is still around, but I believe it's user-space only. (Forgive me if
> I'm wrong here, but it's been a while since I looked at SCST.)

Hi Lee,

That may be a misunderstanding :-) Almost all of SCST runs in the
kernel, except the code for accepting connections from an iSCSI
initiator. The SCST configuration tool (scstadmin) is a user space tool
that interacts with the SCST kernel modules through the SCST sysfs
interface. SCST still has a significant user base despite not being
upstream.

> There is also a cool new extension to targetcli called tcmu-runner, that
> allows you to add new functionality to targetcli without having to hack
> on the kernel.

My understanding is that the design of tcmu-runner is strongly inspired
by the design of the scst_user driver. Something that's unfortunate is
that we can't ask Shaohua Li anymore about the design of tcmu-runner
(see also
https://lore.kernel.org/lkml/398a74fa-6566-8d0d-6434-e68ff3763656@kernel.dk/).

Bart.


