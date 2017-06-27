From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: Permanently change thin provisioning method from user space?
Date: Tue, 27 Jun 2017 14:02:35 +0300
Message-ID: <CAA91j0VCH06Xfk2Hx6ooDnd4+9+Sv1Z+2TY7MmQmgKLoiB0=+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:35267 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752112AbdF0LCh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2017 07:02:37 -0400
Received: by mail-qt0-f177.google.com with SMTP id f92so21190818qtb.2
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2017 04:02:36 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm facing storage system that while generally advertising support for
WRITE_SAME_16 with UNMAP in reality fails this request depending on
exact volume configuration. This configuration is done on storage side
and may happen after host initially discovered LUN.

I though about simply overriding kernel auto-detect with UNMAP using
sysfs scsi_disk/.../provisioning_mode attribute, but it appears kernel
may re-evaluate it in some cases, so changes do not stick. Is it
possible to permanently restrict it per-device (or per-vendor/device)?

TIA

-andrei
