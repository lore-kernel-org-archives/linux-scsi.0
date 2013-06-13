From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: RE:[PATCH 10/10] [RFC] SCSI: esas2r: Add Makefile, Kconfig, and MAINTAINERS
 files
Date: Thu, 13 Jun 2013 17:50:06 +0200
Message-ID: <51B9EA2E.5090501@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:51491 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab3FMPtz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jun 2013 11:49:55 -0400
Received: by mail-bk0-f52.google.com with SMTP id d7so4876892bkh.25
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jun 2013 08:49:54 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bradley Grove <bgrove@attotech.com>
Cc: jseba@attotech.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org

>  S:     Supported
> -F:     drivers/block/nvme*
> +F:     drivers/block/nvme.c
>  F:     include/linux/nvme.h

I don't think you want to change this, it seems you are not generate
your patch set against scsi misc branch?

Regards,
Jack
