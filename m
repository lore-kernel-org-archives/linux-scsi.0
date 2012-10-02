From: adam radford <aradford@gmail.com>
Subject: [PATCH 0/7] megaraid_sas: Updates for scsi for-next
Date: Mon, 1 Oct 2012 19:26:39 -0700
Message-ID: <CAHtARFE3Vt+QVbK4m85uEpapC+ZToBMXsfiWoYtaPr00AFy0Vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48521 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750Ab2JBC0k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2012 22:26:40 -0400
Received: by vcbfo13 with SMTP id fo13so6426342vcb.19
        for <linux-scsi@vger.kernel.org>; Mon, 01 Oct 2012 19:26:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Kashyap Desai <Kashyap.Desai@lsi.com>

James/linux-scsi,

The following patch series for megaraid_sas brings the driver up to
v06.504.01.00-rc1:

1. Remove un-needed completion_lock spinlock calls.
2. Add module param for configurable MSI-X vector count.
3. Load io_request DataLength in bytes.
4. Add array boundary check for SystemPD.
5. Add SystemPD FastPath support.
6. Remove duplicate code.
7. Version, Changelog, Copyright update.

-Adam
