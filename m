From: Jiann-Ming Su <jsu2@emory.edu>
Subject: megaraid unified linking error
Date: Wed, 31 Mar 2004 14:53:41 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0403311451230.11497-100000@callimachus.library.emory.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rosalind.cc.emory.edu ([170.140.204.4]:13726 "EHLO
	rosalind.cc.emory.edu") by vger.kernel.org with ESMTP
	id S262400AbUCaTxm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 14:53:42 -0500
Received: from callimachus.library.emory.edu (localhost [127.0.0.1])
	by rosalind.cc.emory.edu (8.12.11/8.12.11) with ESMTP id i2VJrfmO013657
	for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2004 14:53:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
	by callimachus.library.emory.edu (Postfix) with ESMTP id 6458C18EB6
	for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2004 14:53:41 -0500 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm trying to build the megaraid unified (v2.2.0) on kernel 2.6.4.  It
seems to have compiled fine, but linking, I get:

  drivers/built-in.o(.text+0x5b384): In function `mraid_fini_mbox':
  : undefined reference to `debug_level_g'
  drivers/built-in.o(.text+0x5b5a0): In function `mraid_start_mbox':
  : undefined reference to `debug_level_g'
  drivers/built-in.o(.text+0x5b5d3): In function `mraid_start_mbox':
  : undefined reference to `debug_level_g'
  drivers/built-in.o(.text+0x5b5fc): In function `mraid_start_mbox':
  : undefined reference to `debug_level_g'
  drivers/built-in.o(.text+0x5b61b): In function `mraid_start_mbox':
  : undefined reference to `debug_level_g'
  drivers/built-in.o(.text+0x5b64b): more undefined references to `debug_level_g' follow
  make: *** [.tmp_vmlinux1] Error 1

What kernel option am I missing?  Thanks for any help.
-- 
Jiann-Ming Su  jsu2@emory.edu  404-712-2603
Development Team Systems Administrator
General Libraries Systems Division

