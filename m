Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2974ECCA47B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 15:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbiF3Pw5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 11:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236196AbiF3Pw4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 11:52:56 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C44393F4
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 08:52:56 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 205-20020a1c02d6000000b003a03567d5e9so1580789wmc.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 08:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=PC0C+IYmZqgzCw2evluP2hpSsCJzEX6s3IMX68ULD3E=;
        b=BQ0MJ9j8he4pARfmlw4+bibExLzyDOtJ7jWcxp3azUUdH50JhpGPJFBTjC0lXSKp7c
         XTyA6Qwt62K5K3cAIMAKdFh1xj/g8EWJg385KG11oHyyaumEF6NkiNX1e9YBZC+D5d7P
         90hxajMUydmpD6LOv6d5qzep9j68mOOGrZ//sIACiA6y4g/oPIyqE3b9CDbZGYnsFwfh
         rjgSt5P1IcoESe/8lOOs30GQTNmYwkgp/o20m1v23sced+PJclXBY7mzOa5XeBT/qEn1
         ONJ+GvXojtu3kEaVWrwEt9PM1uZ8AsGI5/YYp3cityXl593ECVovyK9knIBCi64pnfTB
         wB8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=PC0C+IYmZqgzCw2evluP2hpSsCJzEX6s3IMX68ULD3E=;
        b=i1CdHz9v1p7l8O/Lnd7oPwwv5ABnd9rmJctTzCNgKwwQhtUPWP7A0/Y5Uib9AuwU3v
         Sb1w5C8ipiO4UGo0y2kWMYJE2JclhDALBtShqjzQzYV21GELe4b2GUzb2hs7eTkhxrWl
         q50KdN5QhmxgJFhVKCYEGXAau704lfbukvTxWcMRYtfsfRPBxnkC4hyp9vj8xJDw9HyV
         roOoff8DhpwW49Tv/bzLuxDWu2ViqvUTSizM2iFON5aV1eMwm4p6Jt/wzTIIOLl6wFaj
         If6JWfpGNJvAGEAoGdhWCYAUPbG+86LRy8xxFx35QaFJmGCjDdHA2eM4rPcvwRQTY1Sh
         cq9g==
X-Gm-Message-State: AJIora9kLrfds/aQ7le3QOQDpvDZg+LZNWZp+lttTysglyREXDPW3XlG
        JfNhhIbT9Pxwtb6HA3tLGQ8r7CApiQk=
X-Google-Smtp-Source: AGRyM1s8vjc4DjgUuT5fj0UbX5F/sQdf1QCLza687kMVtdY6MtQV5ejYlgNMs0PtrAhFfMID3Q8LCg==
X-Received: by 2002:a7b:c258:0:b0:3a0:42d9:6f51 with SMTP id b24-20020a7bc258000000b003a042d96f51mr12583193wmj.83.1656604374510;
        Thu, 30 Jun 2022 08:52:54 -0700 (PDT)
Received: from DESKTOP-L1U6HLH ([39.53.244.205])
        by smtp.gmail.com with ESMTPSA id z9-20020adfec89000000b0021b89f8662esm19317274wrn.13.2022.06.30.08.52.52
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 30 Jun 2022 08:52:53 -0700 (PDT)
Message-ID: <62bdc6d5.1c69fb81.d338c.530c@mx.google.com>
Date:   Thu, 30 Jun 2022 08:52:53 -0700 (PDT)
X-Google-Original-Date: 30 Jun 2022 11:52:55 -0400
MIME-Version: 1.0
From:   elda.dreamlandestimation@gmail.com
To:     linux-scsi@vger.kernel.org
Subject: Estimating Services
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=0D=0AHi,=0D=0A=0D=0AWe provide estimation & quantities takeoff s=
ervices. We are providing 98-100 accuracy in our estimates and ta=
ke-offs. Please tell us if you need any estimating services regar=
ding your projects.=0D=0A=0D=0ASend over the plans and mention th=
e exact scope of work and shortly we will get back with a proposa=
l on which our charges and turnaround time will be mentioned=0D=0A=
=0D=0AYou may ask for sample estimates and take-offs. Thanks.=0D=0A=
=0D=0AKind Regards=0D=0AElda Pierre=0D=0ADreamland Estimation, LL=
C

