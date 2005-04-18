From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: SCSI trees, merges and git status
Date: Mon, 18 Apr 2005 15:28:38 -0500
Message-ID: <1113856118.4998.70.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:38636 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261158AbVDRU2x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2005 16:28:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: git@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

As of today, I have two SCSI git trees operational:

rsync://www.parisc-linux.org/~jejb/scsi-rc-fixes-2.6.git

and

rsync://www.parisc-linux.org/~jejb/scsi-misc-2.6.git

The latter has a non trivial merge in it because of a conflict in
scsi_device.h, so merges actually do work ...

The trees are exported from BK a changeset at a time (except the merge
bits, which were done manually).  I'll continue to accumulate patches in
the BK trees for the time being since we don't have a nice web browser
interface for the git trees (and also my commit scripts are all BK
based).

Linus, the rc-fixes repo is ready for applying ... it's the same one I
announced on linux-scsi and lkml a while ago just with the git date
information updated to be correct (the misc one should wait until after
2.6.12 is final).

James


