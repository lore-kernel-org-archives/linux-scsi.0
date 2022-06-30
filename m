Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EFAC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 16:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235549AbiF3Qdt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 12:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235669AbiF3Qdr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 12:33:47 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BD63B015
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 09:33:46 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id i1so23620499wrb.11
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 09:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=21qz1Z80+Dw1e1d/lyl4lJ/UQsiXbri/GS0RbMTGIhk=;
        b=Go8BvpBixOW20VGigwHOL+2HGna5TAq1oNHv7SMedVijraV02lFtJouXZaP80MWlCs
         7DTyeO6h4R94UTmQuTaE8IKV48VmOJVbEhst199psy6FvnfY43vlhia+ApNZ1mJYM6B/
         EEHazWuaFm6BWVJij/JHjsAJCzvhksVux6iM/R7goZZvTTTSZrsyYiBqHKeDyWkxgUQ9
         y9AmgdAG7tuFENr8qVD28bjyGZ4JK1M8YoYFUyJjJLbo63MTw78qRZIu0EgxyLqLoYwc
         A5yV/X6Je2zZMAZqkHSZijU8N+tjLR+2wT5s//LEKc8YydVtbYxKu7SpyccuEH1Iiwaw
         jbzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=21qz1Z80+Dw1e1d/lyl4lJ/UQsiXbri/GS0RbMTGIhk=;
        b=ZYS03Na/N626w7Ks4K5fg71Jds9eK6IOiVQL7M5rFHpabW+DMb0adQTJDhzWWSLCyw
         r95L1l8j0KHeCM/XusJc21HkmXamf0ZBygdRpoSzRzWsyffkPTcMvTRWMmxB+x79gLBV
         OE0vYkGdDsqRAZ2ms+TQhkbmnAj37VIxN8S00oKpW9O9mfKFDEas4TYwRtHU0qNNuYCt
         TkQQLiTayDf3wGwJPfUIHgS0mYBP1aHoAa0z6yC1QpVLCdSNykGCssRxBNyfIlqwDk9e
         X9qkT2FjYKLAeFt5DKvELgGAAQCvTn+QL16uE2Jrk8nMxT1ZRy0iPsRdaBW8l96BNP+C
         9xgw==
X-Gm-Message-State: AJIora/ykGEFZkmuXhI2TwtpD3mnRn1SS5rl8gtkVaOhjMtT/Xuexz9J
        nlwviM6ZOXnyQy+RL4kQU43yXqzP1ODvRj//
X-Google-Smtp-Source: AGRyM1vjmGjmcpCOAplHrSi25acvK637I4+Y7BK9Ys502rU7+anHD/7iKPna2UGG/qN6DGi0U/6cmw==
X-Received: by 2002:a5d:5a9d:0:b0:21b:8247:7ec4 with SMTP id bp29-20020a5d5a9d000000b0021b82477ec4mr8937903wrb.561.1656606824689;
        Thu, 30 Jun 2022 09:33:44 -0700 (PDT)
Received: from DESKTOP-DLIJ48C ([39.53.244.205])
        by smtp.gmail.com with ESMTPSA id x10-20020a5d54ca000000b0021b85664636sm19408777wrv.16.2022.06.30.09.33.43
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 30 Jun 2022 09:33:44 -0700 (PDT)
Message-ID: <62bdd068.1c69fb81.7a3c0.550a@mx.google.com>
Date:   Thu, 30 Jun 2022 09:33:44 -0700 (PDT)
X-Google-Original-Date: 30 Jun 2022 12:33:46 -0400
MIME-Version: 1.0
From:   rosario.crosslandestimation@gmail.com
To:     linux-scsi@vger.kernel.org
Subject: Bid Estimate
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,=0D=0A=0D=0AWe provide estimation & quantities takeoff service=
s. We are providing 98-100 accuracy in our estimates and take-off=
s. Please tell us if you need any estimating services regarding y=
our projects.=0D=0A=0D=0ASend over the plans and mention the exac=
t scope of work and shortly we will get back with a proposal on w=
hich our charges and turnaround time will be mentioned=0D=0A=0D=0A=
You may ask for sample estimates and take-offs. Thanks.=0D=0A=0D=0A=
Kind Regards=0D=0ARosario Woodcock=0D=0ACrossland Estimating, INC=
=20

