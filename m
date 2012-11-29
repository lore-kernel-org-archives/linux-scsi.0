From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: mv_chips.h
Date: Thu, 29 Nov 2012 13:48:10 +0900 (JST)
Message-ID: <688785.56474.qm@web100004.mail.kks.yahoo.co.jp>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100004.mail.kks.yahoo.co.jp ([114.111.98.178]:23858 "HELO
	web100004.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751406Ab2K2Eyy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Nov 2012 23:54:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

mv_chips.h

 * Copyright 2007 Red Hat, Inc.
 * Copyright 2008 Marvell. <kewei@marvell.com>
 * This file is licensed under GPLv2.

OK, but someone didn't copy right.

#define mw32(reg, val)	writel((val), regs + reg)

No "caller" will ever pass a WTF expression in reg, only in val.  Ever.

#define iow32(reg, val) 	outl(val, (unsigned long)(regs + reg))

Obviously someone "calls" that macro.  (Without a WTF reg of course.)

#define iow16(reg, val) 	outw((unsigned long)(val, regs + reg))
#define iow8(reg, val) 		outb((unsigned long)(val, regs + reg))

Luckily no one "calls" those macros.
And no one heard my WTF expression when I read them.
