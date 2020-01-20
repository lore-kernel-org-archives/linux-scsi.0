Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6778C33CAF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 03:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 958702070C
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 03:18:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J2Z6ehMC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgATDSQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 22:18:16 -0500
Received: from mail-qv1-f42.google.com ([209.85.219.42]:35287 "EHLO
        mail-qv1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728949AbgATDSP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2020 22:18:15 -0500
Received: by mail-qv1-f42.google.com with SMTP id u10so13413318qvi.2
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jan 2020 19:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=22dHtpqzJ3NWou3Ax1p2njvAHMZVhI8uhtKy8a9uuho=;
        b=J2Z6ehMC124hWJHd/+UmN4vtzeRYwwSetFgge++TndZkgRzayV5YN3pziAbrKMXgoU
         Ybabh2mtpKZQ3Z1EGuufpEV8sbHLY/bywZxtPsnAArciFDger0fWHrTcygKkOuXPgfWq
         yuCoODOytm/s5R/D2NatKwGD1zMHoUPHkvZHVtVcSMIgq54sVzfDZViyQfvTWOQ7xuW6
         zbfoxWQDgkGMrXpWnRaJdFgFaanRcub19N6BQjn7kUsaMUT8rI7xR6//HohEaKzTXfR7
         QYKFPIHXelD5LaJXZ/aHzOTrLWRswX4PGjYtcPfJecBgeVbUnScoGtXf0gFf+3j03VQE
         jKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=22dHtpqzJ3NWou3Ax1p2njvAHMZVhI8uhtKy8a9uuho=;
        b=edZxz1oOrlS8kwIHP/yEfSAlTUpNcyNzdFDPQRDTkeLz6K7XXuRmTbh0bkJDRdLKnu
         eVTBv+1IDPZbbODZb+sQbaaga6dsfefrmjSMVOb1cuEaqWnd/2knaAj9vBSxLCC00DB6
         CLI3jiOUZb3UCzcrBZoGp2HNvvYqoWugW88Fl8TrvxE2aGWtD3Px9Zcmcyn8asexpSqE
         fsRbhWYAAsQGQox1G989ggmSTIf3rUlTOuMHmv/1OYb1UbrFkZeHHADyWJPuy9389J3L
         zHrHO0+XyQZ10RSK2Mr2+ovIvz8+sNVaRQHsVJfuaXA5U+gYYssDCvEJYWPYw9f0bSwY
         oPBw==
X-Gm-Message-State: APjAAAVLv9pjX75Oupf1Jk2XRrJthx0IJ9x2wgXRmSDOilyf+AXwiM3w
        YcH7zq+jDySRJkxlZJTeQl6Og4wm79iIHXvqUL37ZHG9abM=
X-Google-Smtp-Source: APXvYqzVmBee42XhKWFC0K+gch5s81zsXuR2QcOVMGbs0grUtr0fzoGsF7fJ79dOm1ePT2Zly14J5C5+U7ox0EZ0Pco=
X-Received: by 2002:a05:6214:a08:: with SMTP id dw8mr18793644qvb.121.1579490294595;
 Sun, 19 Jan 2020 19:18:14 -0800 (PST)
MIME-Version: 1.0
From:   Weiping Zhang <zwp10758@gmail.com>
Date:   Mon, 20 Jan 2020 11:18:03 +0800
Message-ID: <CAA70yB4DbsHkDnxfD5X4qTPuFKusHSMbe4ciXvg01u7F+RqJoQ@mail.gmail.com>
Subject: [Question] How can I get source code of mpt3sas-24.125.01.00
To:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

How can I get the source code of mpt3sas-24.125.01.00 ?

Thanks
