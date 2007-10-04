From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] critical megaraid bug fix for 2.6.23
Date: Thu, 04 Oct 2007 12:20:56 -0400
Message-ID: <1191514856.9479.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55456 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757838AbXJDQU6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Oct 2007 12:20:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>, Burton Windle <bwindle@fint.org>

This is a critical fix for the reported megaraid inability to boot:

http://lkml.org/lkml/2007/10/2/243

The patch is here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

And the description and diffstat:

commit d5e89385e92a77b2764d9eb8284808a7628cb2a8
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Wed Oct 3 09:00:58 2007 +0900

    [SCSI] megaraid_old: fix READ_CAPACITY
    
    The bulk transfer mode got eleminated by
    3f6270ef76f2ce5c134615a470685d6c2a66c07e.  Unfortunately, this mode is
    required for READ_CAPACITY commands on certain cards, so put it back
    again.  This fixes a boot failure regression reported by Burton
    Windle.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

 megaraid.c |    8 ++++++++
 1 file changed, 8 insertions(+)

James


