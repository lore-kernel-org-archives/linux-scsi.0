From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Reorg of source lio-core-2.6.git/drivers/lio-core
Date: Thu, 02 Oct 2008 15:00:06 -0700
Message-ID: <1222984806.15764.144.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:27154 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754390AbYJBWAI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 18:00:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vg>

Greetings all,

I just wanted to mention that I made the commit that renamed the source
and header files in drivers/lio-core/Makefile:target_core_mod-objs to
use the target_core_* prefix.

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commit;h=e53c989a9f0d1d50875deedd87a5a1d88a3dae52

This should make things alot easier for folks who are reading the code
to see and understand the split between target_core_mod and
iscsi_target_mod, as well as the split between target_core_mod and Linux
storage subsystem plugins..

There are still some functions/defines that use the ISCSI_* and/or
iscsi_* prefix in target_core_* code, as well as iscsi_target_core.h
needs to be seperated out into target_core_mod.h.  I will be spending
time on finishing up these parts soon, so if anyone is interested in
learning how things work (I will happily accept patches too :-) please
have a look at: 

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=tree;f=drivers/lio-core;hb=HEAD

--nab

