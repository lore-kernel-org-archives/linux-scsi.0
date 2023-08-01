Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666ACC0015E
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 12:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbjHAMRV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 08:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbjHAMRR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 08:17:17 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE085210D
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 05:16:45 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id a1e0cc1a2514c-79a2d0e0ce6so1345229241.3
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2023 05:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690892203; x=1691497003;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P7KMPAGh6NlnTnD5lkpWaGqJsOcwuB2UI/6mC3n3LBk=;
        b=mjtZY3OFs3s5aOiEaSCQBZoAvipmtOnrzzQPqVNlqs4d8Q0VcoZNYI4+02y449Gisl
         f2DXV5YbjUT1Drj2gQwXWN02RaaMK6ssN8JdHIguPJ2L+JIlLTDhO7ue+gaqBGqYS6id
         RGd04rkmQXdwY9cr3tknVf8xP7w8WKWHIAwbIGBh2mUQSWFpjmb9NYwv36ZR/b6WQlfX
         0xkp0+ckyPSLkEcR5H4xHy42OPfPsKjxswNntwGOiCa7vrmg6W+dPtARb+ICYTJ9UmcT
         LYWa89MjW2aU5eIgDWc1t+1rPx25P7+xcR+CJdgcNW0PPxdOh1yTvtsbUyrAOJokN+oe
         7tWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690892203; x=1691497003;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P7KMPAGh6NlnTnD5lkpWaGqJsOcwuB2UI/6mC3n3LBk=;
        b=Ejq8pQGH9MNEX2VOaEoWr1giP7QyE1RxmWxjwnyT5fVo4xQNWkYBK94Uu2lEvmUNJS
         cPIqgglLdaDA8+N1wPacKZO/E8ir6W/WyHHqLRgvdjN+PH7T5iJeHTZTH9LnfzP4Pec8
         Mxix2K6KiKY9MX24EWfmUmfVqLpPZEEJ7EJG7qkUvzFsJW31HNNpq53DhyaWOV3r1StQ
         2w2ahy32OFrIOjqPYv7IuiOe0rsP9t+yV2dGY+NdxyHN/AjNg1xFWT5UKtBzneWRoBdH
         1K1OPghttqiW1xsKsZxuyk/avLE94WVDn+9i9fXBCHQEm3nUyAh+R0uSWBLz/0Q+85+p
         IbLQ==
X-Gm-Message-State: ABy/qLahFq6iAtTaOma7BFtbf2958fGtHxvRLKAX8peHqXwlBBI/Oj1o
        o6Ag1pZvHvrN5J+g+zdqa/eoO0tc9CYnDdJ2qjbmvy+QBNMQfKHp83Q=
X-Google-Smtp-Source: APBJJlGcvvgozeFW/7IFKU0qI9C3S2si5rDkhW2xeQeDdaCu0/6DDLOfEK/KM+GujWYsL45S5btDzQNNtA12BUGslbo=
X-Received: by 2002:a05:6102:87:b0:443:6c48:4d49 with SMTP id
 t7-20020a056102008700b004436c484d49mr1506490vsp.10.1690892203480; Tue, 01 Aug
 2023 05:16:43 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Aug 2023 17:46:32 +0530
Message-ID: <CA+G9fYur8UJoUyTLJFVEJPh-15TJ7kbdD2q8xVz8a3fLjkxxVw@mail.gmail.com>
Subject: next: arm64: gcc-8-defconfig: ufshcd.c:10629:2: /builds/linux/include/linux/compiler_types.h:397:38:
 error: call to '__compiletime_assert_553' declared with attribute error:
 BUILD_BUG_ON failed:
To:     open list <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Following build error noticed while building Linux next-20230801 tag
arm64 defconfig with gcc-8 toolchain.

Regressions found on arm64:

  - build/gcc-8-defconfig
  - build/gcc-8-defconfig-40bc7ee5


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

log:
-----
In function 'ufshcd_check_header_layout',
    inlined from 'ufshcd_core_init' at
/builds/linux/drivers/ufs/core/ufshcd.c:10629:2:
/builds/linux/include/linux/compiler_types.h:397:38: error: call to
'__compiletime_assert_553' declared with attribute error: BUILD_BUG_ON
failed: ((u8 *)&(struct request_desc_header){ .enable_crypto = 1})[2]
!= 0x80
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                      ^


Links:
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230801/testrun/18754886/suite/build/test/gcc-8-defconfig/log
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230801/testrun/18754886/suite/build/test/gcc-8-defconfig/details/
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230801/testrun/18754886/suite/build/test/gcc-8-defconfig/history/


--
Linaro LKFT
https://lkft.linaro.org
