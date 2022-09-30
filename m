Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9967C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 11:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiI3LFn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Sep 2022 07:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiI3LFW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2022 07:05:22 -0400
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3F31ABFCC
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 03:42:24 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id x29so4351532ljq.2
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 03:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date;
        bh=b6dAZcyQPz5vGGupID9LKR99Sy2ZmwGKgLUySQfiCtQ=;
        b=QRHsoGRO4uWyzlXap5LaibjqWD+X9Jf4Hbl/o1OQmszzf1vNUo8NoSQ8OwEruk0Epw
         4zxLh6dWxX4AmImVURIBOMG6/RWB4WnItE1opDxpXc28Sb20A/Ir7teVRQyWRc/QfBT4
         ZBet89uaZJHVN/bg0n1xxcihjNsEJgqFGVCp8mxsE5CkNqVv8IW9McV4Cf9aBTlA6oHS
         deLWWzsqofHtciJLPFvxKgNr7O5UwnXDRrt/3Bwj77FU4qYd0YdFNzfRh69jbE1fHlti
         3QxIJZIQYOXuUibAQbSRobTXZglr6pcXLMsmDLPUNZKFwepLKt8zKsNijU0w+K5nODqx
         Oc0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=b6dAZcyQPz5vGGupID9LKR99Sy2ZmwGKgLUySQfiCtQ=;
        b=IKQBwor7cRXPxefRM8AGzPNv4ouBHndEfkHiPNDfXNi8zrpbspN6vsUfek2svL341A
         u4S9AKDJ1pRAYEIIKOa0/I/EELHCjJswTlo+2HQHt81gEiEUIYj+kpoH84Rqu5YCKFzs
         5IuqIAuZ3V/8+RGmliOnlgrRX6fBf1ZQQj+x7V2HYAxc5tQtlhZaNHpG9NKUKWXFYcJ7
         zSSyBG9/3ysP4FNx6JxqQPinUC5/3veowqjJ2EjnyfVaCFuMMO6OXVLHUYqALIYFGXNH
         UxHlyRWmvSgao1cIDWnAydn1Ls376vI7sO4ud2IcdTScrMXao/DhFasrWkTM+d+8ev0V
         GBVw==
X-Gm-Message-State: ACrzQf2Jn4dcIW1JVVQz47BRGMnOMcszf1cHV32Qai/XA0pCuch5oh9v
        MBb2jvs8vhpaP49DJWOVUBwkXTSYt/RnXA==
X-Google-Smtp-Source: AMsMyM77hQvwgXDDe9Ut6SPybPLRMbIDn4gUltdLx2cyFZT8X0NV5lJdyWGVN2UQaRmkd6bAkPXO3g==
X-Received: by 2002:a17:906:fd84:b0:730:acee:d067 with SMTP id xa4-20020a170906fd8400b00730aceed067mr6115658ejb.206.1664533600898;
        Fri, 30 Sep 2022 03:26:40 -0700 (PDT)
Received: from [10.176.234.249] ([137.201.254.41])
        by smtp.googlemail.com with ESMTPSA id ku26-20020a170907789a00b0077085fdd613sm986031ejc.44.2022.09.30.03.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 03:26:40 -0700 (PDT)
Message-ID: <d926c507e6dc685c74256cbf36a65f5e397063c5.camel@gmail.com>
Subject: Re: [PATCH v3 4/8] scsi: ufs: Remove an outdated comment
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Date:   Fri, 30 Sep 2022 12:26:39 +0200
In-Reply-To: <20220929220021.247097-5-bvanassche@acm.org>
References: <20220929220021.247097-1-bvanassche@acm.org>
         <20220929220021.247097-5-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-09-29 at 15:00 -0700, Bart Van Assche wrote:
> Although the host lock had to be held by
> ufshcd_clk_scaling_start_busy()
> callers when that function was introduced, that is no longer the case
> today. Hence remove the comment that claims that callers of this
> function
> must hold the host lock.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>
