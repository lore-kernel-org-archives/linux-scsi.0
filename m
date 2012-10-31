From: Vineet Agarwal <checkout.vineet@gmail.com>
Subject: Help to co-relate the scsi device with dev_t (device num)
Date: Wed, 31 Oct 2012 18:03:40 +0530
Message-ID: <CAKXPQgUc9=4u+xL11Wr-ubXnm8S6ro7BbqurX3NV-6MD0PM08A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55597 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531Ab2JaMeC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2012 08:34:02 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so1023824lbo.19
        for <linux-scsi@vger.kernel.org>; Wed, 31 Oct 2012 05:34:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hello,

I'm writing a kernel code where I need to co-relate the scsi device
with linux dev_t.

I thought that having a scsi_device and then referring the dev_t
number would solve the problem. But the dev_t output received is zero.

scsi_device *sdev = scsi_device_lookup()
tried printing =>  sdev->sdev_dev.devt
tried printing => sdev->sdev_gendev.dev_t

Is the dev_t really set when a driver do a scsi_add_device ?
If yes, Please let me know what i'm doing wrong ?

If not, Please help me as what is right way to find the dev_t for a
given scsi-device.

Thanks,
Vineet
