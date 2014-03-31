From: Laurence Oberman <oberman.l@gmail.com>
Subject: scsi_debug driver puzzle
Date: Mon, 31 Mar 2014 13:32:19 -0400
Message-ID: <CAAzz28gZtn5HaXwQvmvnyK0wAWn-9et8Z8ZL9HVYDvLqFv9ibA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:57320 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbaCaRcU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2014 13:32:20 -0400
Received: by mail-la0-f53.google.com with SMTP id b8so6155027lan.12
        for <linux-scsi@vger.kernel.org>; Mon, 31 Mar 2014 10:32:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello

I have what to me is a puzzle but is likely a stupid question about
the queuecommand interface in the scsi_debug driver.

I see the host template set for  scsi_debug_queuecommand but in the
driver we have the function declared as int
scsi_debug_queuecommand_lck
So how is this working.

Egrep pattern: scsi_debug_queuecommand

  File         Line
0 scsi_debug.c 3551 int scsi_debug_queuecommand_lck(struct scsi_cmnd
*SCpnt, done_funct_t done)
1 scsi_debug.c 3900 static DEF_SCSI_QCMD(scsi_debug_queuecommand)
2 scsi_debug.c 3912 .queuecommand =  scsi_debug_queuecommand,

Thanks
Laurence
