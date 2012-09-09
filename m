From: Arvydas Sidorenko <asido4@gmail.com>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
Date: Sun, 9 Sep 2012 22:34:16 +0200
Message-ID: <CA+6av4mdQ3daHHakRDCmHR_zMfcA_cAoabSuwBrcfjpYgUcXyg@mail.gmail.com>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
	<20120703090441.GA4804@gmail.com>
	<4FF351F8.1000003@msgid.tls.msk.ru>
	<20120704024715.GA17095@gmail.com>
	<4FF3E478.50609@msgid.tls.msk.ru>
	<20120704070604.GA17769@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52679 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab2IIUeR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2012 16:34:17 -0400
In-Reply-To: <20120704070604.GA17769@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>, Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>

> Meanwhile there already has a number of SATA disks that have supported
> this feature.  So I think maybe we can enable it.
>
> Regards,
> Zheng

Blindly enabling FUA by default in my opinion is not a good idea at all.
I believe the focus should be on detecting FUA support on the device
instead, which the kernel at this point cannot reliably do (is it possible?).

This patch introduced regression: https://lkml.org/lkml/2012/8/27/66

Arvydas
