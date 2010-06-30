From: Alex <mysqlstudent@gmail.com>
Subject: aacraid problems on 2.6.35-rc3
Date: Wed, 30 Jun 2010 10:28:09 -0400
Message-ID: <AANLkTimvQtYPh_6ZeKiGz2-eZf_pVy6N7TwEeXCoq0Iv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35548 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab0F3O2L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jun 2010 10:28:11 -0400
Received: by gwb15 with SMTP id 15so398086gwb.19
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jun 2010 07:28:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm trying to compile a kernel with aacraid support on a dual Opteron
246 box with two 36GB disks on a Tyan S2891, using an initrd and lilo.

There is an older kernel on there that works just fine, so I suspect
it's something I'm missing in the kernel config. No matter what I try,
the kernel fails to find the disks on the controller. I've even tried
building it without an initrd and compiling everything into the
kernel, but it still panics.

I've included the aacraid support, SCSI disk, SCSI generic, and even
RAID1/5 support. The controller and motherboard also have the latest
BIOS updates.

What else is necessary to support aacraid?

It only prints the following when booting:

Adaptec aacraid driver 1.1-5[2456]-ms

Is I2O or ACPI support necessary?

Are there any boot-time options to increase debugging output to
troubleshoot this?

The dmesg output from a working system is here:

http://pastebin.com/0AnVBV7s

The kernel config for the attempt is here:

http://pastebin.com/gi9ybDwS

Thanks for any ideas.
Best regards,
Alex
