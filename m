From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 0/2] scsi tgt updates (replace the elevator code)
Date: Thu, 16 Mar 2006 09:04:10 +0900
Message-ID: <20060316090410E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:27099 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S932616AbWCPAES
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Mar 2006 19:04:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Here's another patchset to synchronize the scsi-target git tree with
the latest code in the subversion repository. This patchset replaces
the elevator code with a simple list.

This patchset assumes that the previous patchset is applied.

http://marc.theaimsgroup.com/?l=linux-scsi&m=114199144502121&w=2
