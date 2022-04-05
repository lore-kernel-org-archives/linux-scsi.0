Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF36BC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 01:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241394AbiDFBBy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447682AbiDEPq6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 11:46:58 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D086158BBF
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 07:22:44 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id bx5so11991390pjb.3
        for <linux-scsi@vger.kernel.org>; Tue, 05 Apr 2022 07:22:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=BTcTVepOiUTD2wL9RJTfNH1XZZ48aFwIiqkmOvKNMMM=;
        b=02Lg6Z924yC6PVg0nMl+l0q1E3+I6iS91LofN9Xv4x16JhbEW3k85Czu/hD9XOwWXL
         RlKilAep/rNwtHp+CcJUwvEk0bSNRByTljJqnTXCy3B6ByYxZNSNEPJYa2vJpFkHJyNd
         xaVLBVVLbKf438D9mDLqN9NOEiOn7IdtiwcG/HnNWYglf71KyClrExUJaPo9dpoWB4zk
         2g7zYOMVOggwkZODGKv0A3qQg+rqT6p0IG4SZiCPtnJSfeGPvt59ChAFewQcyqJnQlj3
         ySfa+CmC8yZn3mWdjTeCHQU/1mHx/BfQvigYzqmSNZ2Q2E7Pt4QapVSkAu9uaqqLgDwh
         2RwQ==
X-Gm-Message-State: AOAM531k6hsWiFDcseYWoW7Ch0zcgmZssQoQrSqrYqMw0Mh10U9925I/
        QcBuNjNVZzEJNvtwizb51yw=
X-Google-Smtp-Source: ABdhPJyimRXsrKDRVoBkMayNa0tXFlEASzSxGMISwVgeoG+Fwx5jpn/lLxn5dSu2QRB/vLVQp5iOXA==
X-Received: by 2002:a17:90b:3ecb:b0:1c7:5634:df6f with SMTP id rm11-20020a17090b3ecb00b001c75634df6fmr4465429pjb.184.1649168564161;
        Tue, 05 Apr 2022 07:22:44 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id z6-20020a17090a66c600b001ca7dbe1bc2sm2707328pjl.46.2022.04.05.07.22.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:22:43 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------jaqWYRVZg7FDbRrM0ywyvK4G"
Message-ID: <ca7dff5d-ad32-fafe-d522-f455be04e2ef@acm.org>
Date:   Tue, 5 Apr 2022 07:22:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 00/29] UFS patches for kernel v5.19
Content-Language: en-US
To:     Bean Huo <huobean@gmail.com>, Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        quic_cang@quicinc.com
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <60dc8a92c7eda8f190a8a6123bc927e8403bdbb1.camel@gmail.com>
 <eee8d304-aacd-9116-9e2d-92e2e3682b5b@acm.org>
 <DM6PR04MB6575DBC3CFAD57F5AA19DCF8FCE29@DM6PR04MB6575.namprd04.prod.outlook.com>
 <9bff98fa4a4a8a61a5c46830ef9515a7dfddcb89.camel@gmail.com>
 <ebf3cc31-9cd1-3615-b033-06bfc7d25b9a@acm.org>
 <94902f1e26a18ff7774dc429502bef7d54f23b5d.camel@gmail.com>
 <5073d69e-20c4-0fce-a045-47c52e2d3424@acm.org>
 <2eea6ffcd83233a93a8a7ebfc24a58516cd6e79a.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2eea6ffcd83233a93a8a7ebfc24a58516cd6e79a.camel@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------jaqWYRVZg7FDbRrM0ywyvK4G
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/5/22 02:33, Bean Huo wrote:
> For performance improvement, according to my test, if we abandon SCSI
> command parsing, we can get 3%~5% performance improvement. Maybe this
> is little or no improvement? Yes, reliability issues outweigh this
> performance improvement. Error handling and UFS probes should also be
> rebuilt. But most importantly, it makes UFS more scalable. How do you
> think about adding an immature development driver to drever/staging
> first? name it driver/staging/lightweight-ufs?

I do not understand the interest in bypassing the SCSI core. The 
scsi_debug driver supports more than a million IOPS on a single CPU core 
(see also the attached script). I think this shows that the SCSI core is 
not a performance bottleneck. Additionally, I think it will take a while 
until UFS devices scale from the current performance level (100K IOPS?) 
to more than a million IOPS.

Please note that bypassing the SCSI core would make it much harder than 
necessary to introduce zoned storage support and also that this would 
lead to plenty of duplicated code.

>> For other SCSI LLDs the cost of
>> atomic operations and memory barriers in the LLD outweighs the cost
>> of
>> the operations in the SCSI core and sd drivers. I'm not sure whether
>> that's also the case for the UFS driver.
> 
> I didn't take this into account, maybe it's not a big deal, since the
> UFS driver might use its own lock/serialization lock.

Every single atomic operation in the hot path has a measurable 
performance impact. That includes locking operations.

Thanks,

Bart.
--------------jaqWYRVZg7FDbRrM0ywyvK4G
Content-Type: text/plain; charset=UTF-8; name="scsi_debug-iops"
Content-Disposition: attachment; filename="scsi_debug-iops"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCnNldCAtZQoKaW9kZXB0aD0kezE6LTF9CnJ1bnRpbWU9MzAKYmxvY2tz
aXplPTUxMgpudW1jcHVzPSQobnByb2MpCgptb2Rwcm9iZSAtciBzY3NpX2RlYnVnCm1vZHBy
b2JlIHNjc2lfZGVidWcgbWF4X3F1ZXVlPTEyOCBzdWJtaXRfcXVldWVzPSIkbnVtY3B1cyIg
ZGVsYXk9MCBmYWtlX3J3PTEgJiYKICAgIHVkZXZhZG0gc2V0dGxlCgpERVZJQ0U9JChmaW5k
IC9zeXMvYnVzL3BzZXVkby9kcml2ZXJzL3Njc2lfZGVidWcvYWRhcHRlciovaG9zdCovdGFy
Z2V0Ki8qL2Jsb2NrLyAtbWF4ZGVwdGggMSAtdHlwZSBkIHwgZ3JlcCAtdiAnYmxvY2svJCcg
fCBoZWFkIC0xIHwgeGFyZ3MgYmFzZW5hbWUpIHx8IGV4aXQgJD8KWyAtbiAiJERFVklDRSIg
XSB8fCBleGl0ICQ/CgphcmdzPSgpCmlmIFsgIiRpb2RlcHRoIiA9IDEgXTsgdGhlbgoJYXJn
cys9KC0taW9lbmdpbmU9cHN5bmMpCmVsc2UKCWFyZ3MrPSgtLWlvZW5naW5lPWlvX3VyaW5n
IC0taW9kZXB0aF9iYXRjaD0kKChpb2RlcHRoLzIpKSAtLWhpcHJpPTEpCmZpCmFyZ3MrPSgK
ICAgIC0tYnM9IiR7YmxvY2tzaXplfSIKICAgIC0tZGlyZWN0PTEKICAgIC0tZmlsZW5hbWU9
L2Rldi8iJERFVklDRSIKICAgIC0tZ3JvdXBfcmVwb3J0aW5nPTEKICAgIC0tZ3RvZF9yZWR1
Y2U9MQogICAgLS1pbnZhbGlkYXRlPTEKICAgIC0taW9kZXB0aD0iJGlvZGVwdGgiCiAgICAt
LWlvc2NoZWR1bGVyPW5vbmUKICAgIC0tbmFtZT1zY3NpX2RlYnVnCiAgICAtLW51bWpvYnM9
MQogICAgLS1ydW50aW1lPSIkcnVudGltZSIKICAgIC0tcnc9cmVhZAogICAgLS10aHJlYWQK
ICAgIC0tdGltZV9iYXNlZD0xCikKc2V0IC14CmlmIG51bWFjdGwgLW0gMCAtTiAwIGVjaG8g
PiYvZGV2L251bGw7IHRoZW4KCW51bWFjdGwgLW0gMCAtTiAwIC0tIGZpbyAiJHthcmdzW0Bd
fSIKZWxzZQoJZmlvICIke2FyZ3NbQF19IgpmaQo=

--------------jaqWYRVZg7FDbRrM0ywyvK4G--
