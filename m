From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/2] iscsi: convert to use the data buffer accessors
Date: Fri, 1 Jun 2007 18:56:19 +0900 (JST)
Message-ID: <dcbf60d819ad4d62643fc074968699563f25621b.1180539510.git.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:60199 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117AbXFAJ4j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jun 2007 05:56:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com, michaelc@cs.wisc.edu, open-iscsi@googlegroups.com

This patchset converts libiscsi, iscsi_tcp, and iscsi_iser to use the
data buffer accessors.

This is dependent on the patchset that Mike posted the day before
yesterday (which is on the top of the latest scsi-misc-2.6):

http://marc.info/?l=linux-scsi&m=118054788406095&w=2

This can be also cleanly applied to Mike's iscsi git tree.

iscsi_tcp and iscsi_iser needs some modifications to use
scsi_for_each_sg macro so I've not done that. It would be easier to
use the chaining sg macros like next_sg directly when they are ready.
