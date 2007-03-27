From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.21-rc5
Date: Tue, 27 Mar 2007 11:24:37 -0500
Message-ID: <1175012677.3737.18.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:58973 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933012AbXC0QYw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Mar 2007 12:24:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a fairly basic rollup of 3 basic double free or oops based bug
fixes.

The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The Short Changelog is

Joerg Dorchain (1):
      gdth: fix oops in gdth_copy_cmd()

Judith Lebzelter (1):
      mptsas: Fix oops for insmod during kexec

Linas Vepstas (1):
      lpfc: avoid double-free during PCI error failure

and the diffstat:

 message/fusion/mptsas.c |    7 +++++--
 scsi/gdth.c             |    2 ++
 scsi/lpfc/lpfc_init.c   |    5 ++---
 3 files changed, 9 insertions(+), 5 deletions(-)

James


