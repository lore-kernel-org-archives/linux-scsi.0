From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/3] tgt fixes
Date: Sat, 3 Mar 2007 09:55:53 +0900 (JST)
Message-ID: <20070303001744L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:38778 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992819AbXCCA4E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Mar 2007 19:56:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This patchset fixes sense buffer handling bugs and scsi command leak
with cleanups to remove bio hacks.

The patchset are made over scsi-rc-fixes tree.
