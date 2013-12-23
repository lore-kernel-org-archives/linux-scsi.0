From: Junliang Li <lijunliang.dna@gmail.com>
Subject: Can we use SCSI error trace events to monitor SCSI hardware
 problems ?
Date: Mon, 23 Dec 2013 11:28:23 +0800
Message-ID: <1387769303.2695.20.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:57892 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab3LWD23 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Dec 2013 22:28:29 -0500
Received: by mail-pa0-f48.google.com with SMTP id rd3so4820696pab.21
        for <linux-scsi@vger.kernel.org>; Sun, 22 Dec 2013 19:28:29 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: linux-scsi@vger.kernel.org

Hello, Hannes

I found you owned a project on github named "md_monitor". It supports MD
array by using mdadm tool. But how about generic SCSI devices ? There is
a "scsi_dispatch_cmd_error" tracepoint in SCSI subsystem, from which we
can get something useful output via sysfs.  We can do more work in
userspace. Now I setup a tracepoint in "scsi_print_result" and trace
scsi cmd result. By reading host status and sense data, I can find out
anything wrong while executing SCSI commands. Does it make sense or it
could be better ?

Thanks,
Junliang Li

