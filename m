From: "HINCHMAN,PAUL (HP-Roseville,ex1)" <paul_hinchman@hp.com>
Subject: Enterprise patch needed - please help
Date: Wed, 29 May 2002 16:23:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <6BD67FFB937FD411A04F00D0B74FE87807C249F0@xrose06.rose.hp.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xparelay1.corp.hp.com (xparelay1.corp.hp.com [15.58.136.173])
	by palrel12.hp.com (Postfix) with ESMTP id B982EE00AAC
	for <linux-scsi@vger.kernel.org>; Wed, 29 May 2002 16:23:38 -0700 (PDT)
Received: from xpabh1.corp.hp.com (xpabh1.corp.hp.com [15.58.136.191])
	by xparelay1.corp.hp.com (Postfix) with ESMTP id B1B9FE000A8
	for <linux-scsi@vger.kernel.org>; Wed, 29 May 2002 16:23:38 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Dear SCSI maintainers,

We need desparately a patch (or better yet) permanent integration of an
enablement for Linux to see max_scsi_luns "out of the box", at least in
"enterprise" kernels.  I'm not a coder, but I do test Linux connectivity to
mass storage over fibre channel.  It's easy enough to go into xconfig or
menuconfig and enable 128 LUN's, then build a new kernel.  However, doing so
negates support from whatever vendor (like SuSE and Red Hat).  So, an
"out-of-the-box" solution is desparately needed.  Linux won't go far in the
enterprise without fully enabled (and stress-tested) storage.  I'd like to
see this change to the 2.4.18+ kernels and beyond, I think it would probably
be simple. Any advice you folks could give me as to who to talk to and
escalate this issue would be great.  I'll provide more info to anyone who
thinks they can help.

R/

Paul Hinchman
NSAS Linux Connectivity Lab
HP Roseville, CA
916.785.2346
