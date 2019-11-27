Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BD5C432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 17:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3E082073F
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 17:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfK0Ree (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Nov 2019 12:34:34 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33981 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfK0Ree (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Nov 2019 12:34:34 -0500
Received: by mail-pf1-f194.google.com with SMTP id n13so11376970pff.1;
        Wed, 27 Nov 2019 09:34:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lYbQXx2Q7vU4bWeO+6Aod/O84LeoB/V0z58WhrtpaIQ=;
        b=q44IOwfR+LLd8UruF6AMFVnBIR2BD+nRhp8meB0tTl+37klkpjErIqf0WpMeQVSZ7Y
         9qDLIdC17PMkoDKPVcF3DeQaZPqdrcfAVMoKedH/ii5rDsYEIqWkYWWTpcqXSfjs0umD
         TaD3zlfo/5MuWv1VxJD45Xc08RipE3TU8DntuQSRnC2PpbPkduP9+d1LeIOMmRzP+Vvy
         jRUZVRwqjtHv4lc/+5OHVqBzNGmE9aorYhzSwEM/lg7A5tc7rWM/fB0pmlbJu5DAiQGH
         dOQLkgwz3dfjrzFgyOWUy64+QIVYv72PA0osn60sR7DB4gq/Q5WAwNkj0uBxycBXalK7
         pzQA==
X-Gm-Message-State: APjAAAWMyCYnZmS7ytXdc9Nh7fNCHc97gUVZlegEbTNP+UGcokGMUUKy
        RonezUp0NgconepJIMWJM7c=
X-Google-Smtp-Source: APXvYqxsM3mozkLbHky4xv9oqwU+j1zl9iy5Obs/yG29rzSvxcPxD5AE058ZK3CjPGIOwRO1FKf3qw==
X-Received: by 2002:a62:5216:: with SMTP id g22mr46872242pfb.78.1574876073414;
        Wed, 27 Nov 2019 09:34:33 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id o8sm2913355pjo.7.2019.11.27.09.34.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 09:34:32 -0800 (PST)
Subject: Re: [PATCH v3 00/13] scsi: qla2xxx: Bug fixes
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux@yadro.com
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
 <347fd571-89d7-2b7e-fd88-1711002c3fb9@acm.org>
 <20191127172427.jpqfopou7y6kyrev@SPB-NB-133.local>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d9366987-ab6a-9124-39e1-d70887c88757@acm.org>
Date:   Wed, 27 Nov 2019 09:34:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191127172427.jpqfopou7y6kyrev@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/27/19 9:24 AM, Roman Bolshakov wrote:
> On Tue, Nov 26, 2019 at 12:56:51PM -0800, Bart Van Assche wrote:
>> On 11/25/19 8:56 AM, Roman Bolshakov wrote:
>>> The patch series contains fixes for qla2xxx and solves two visible
>>> issues: [ ... ]
>>
>> As explained in Documentation/process/2.Process.rst, please post patches
>> outside the merge window.
> 
> Thank you for the reference. Could you please assess if my understanding
> of the document is correct:
> 	The fixes might go into 5.5-rc2 after the release of rc1 which
> 	closes the merge window.
> 
> 	No patches except critical for -rc1 should be posted when the
> 	merge window is opened.

Hi Roman,

During the merge window many maintainers and core contributors are busy 
with identifying and addressing regressions introduced during the merge 
window. I think that is why the merge window is not the best time to 
post patches and why that text was added to the kernel documentation.

What happens with patches posted during the merge window depends on the 
maintainer (Martin Petersen). Sometimes patches posted during the merge 
window are ignored. Sometimes such patches are queued after the merge 
window has closed. Sometimes contributors are asked after the merge 
window has closed to rebase their patch series, to retest it and to 
repost it. The latter makes sense because the changes accepted during 
the merge window (e.g. core kernel API changes) may require matching 
changes in a patch series. You may want to ask Martin directly which 
approach he prefers after the merge window has closed.

Bart.
