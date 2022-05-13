Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03D2C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 May 2022 02:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376630AbiEMC4x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 22:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376620AbiEMC4w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 22:56:52 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AD636163
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 19:56:47 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id p3so5802996qvi.7
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 19:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=YfSyf8u/NtA/eLp0tCJ7Xe0+tnTmVim4H2pL0vEsIiU=;
        b=0mtoDTP0h+78pMTFKFTp5W2xjK1hcv0lNhcN1E0ldAU+KruS88+d+eKT2j8jX6aaTf
         xAxUnsQAhUijY/zcRao1hzMIrncEkUQ7nqKG5CKm/fhS0lLzQPWv03XD05t+jSF3w6Fp
         n4j1+9tNGrnptsTapwM26mibHHeRH17d1wRomMrwpfe2j7TM/ooGkiFYVV+0K/umc9wB
         iESWL4SXlQ0yjffaoKRY7NnCK6mRZdwVxtpBjlzXR2ZLXnLe8Y0U7R78A/K8FtX1L+vo
         fD8Dz1+4qi03W5jcPkFTNU5uJuLkxQcOfBS2F1Axp3kuB4kReBr4cLOPA+EUDC4RKVV0
         25kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=YfSyf8u/NtA/eLp0tCJ7Xe0+tnTmVim4H2pL0vEsIiU=;
        b=QIf5JSHBuHh0MTk7XVTzDCqnoO0kEo9TloVfQRm22XYduHc0OGGIwW1B/Xq+vtlb4e
         RVhvvhyphhjszkmuxbLY3kkWDbHa491fWomGLWmfU4/galK1V1tm1l8co0/hvMYWozQm
         ekJy1TOy0ix4vxwgdxVcZW+Y5PX4FVMExJUXhJpWCEtPa7jrkAI107OIWuv3GMDUz2DJ
         5UM9V2kP/0GWFU8jwG7Ls9iFr/30MMZFdK0Pt/OE/G4d0qrChr7PlWEHoIJ5qgjNvCas
         BIapNsZs66L2YuRYuFUO08WZdoOsPaELxemAqHm4zKx/15/3FjwIOqJzuSMjkFqVoRkr
         H6Hw==
X-Gm-Message-State: AOAM532BvQddZejHeDMAWXazYf9pTgtpqN77Lqi630sXAbuIUiO4foal
        gId1lDTM/URsJQYqz7utqJIpyw==
X-Google-Smtp-Source: ABdhPJwEkF4mdxyhyJw1VUq1yi0cunHOiqDqtKhsTWuDuqm6cZSOXpnjZ7qhYCMJiPw/3cavmMdKaw==
X-Received: by 2002:a05:6214:2aae:b0:45b:3d6e:e6e6 with SMTP id js14-20020a0562142aae00b0045b3d6ee6e6mr2865442qvb.111.1652410606448;
        Thu, 12 May 2022 19:56:46 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id e1-20020a05620a208100b0069fc13ce205sm686031qka.54.2022.05.12.19.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 19:56:45 -0700 (PDT)
Date:   Thu, 12 May 2022 22:56:44 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-block@vger.kernel.org, bpf@vger.kernel.org,
        lsf-pc@lists.linuxfoundation.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: LSF/MM/BPF 2022: Slides and thanks!
Message-ID: <Yn3I7KZeuJQqVFHi@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

Thank all of the participants of this years LSF/MM/BPF! It was great to finally
get together as a community, both in person and virtually.

If you presented this year and had slides please email the slides to
lsf-pc@lists.linuxfoundation.org so we can attach it to the videos when the
recordings are uploaded to YouTube. We will also forward these along to the
staff at LWN.

If any of you have objections to your sessions being posted on YouTube please
email the lsf-pc list so we can make sure to exclude those videos.  We already
have a couple of requests, so if you've already made one you don't need to let
us know, we already have it marked down.

Thanks again for a great conference!

        Josef Bacik (Filesystems)
        Amir Goldstein (Filesystems)
        Martin K. Petersen (Storage)
        Omar Sandoval (Storage)
        Michal Hocko (MM)
        Dan Williams (MM)
        Alexei Starovoitov (BPF)
        Daniel Borkmann (BPF)

