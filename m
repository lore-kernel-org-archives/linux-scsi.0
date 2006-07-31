From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 0/4] fusion: fibre channel: misc. fixes
Date: Mon, 31 Jul 2006 12:19:17 -0500
Message-ID: <44CE3B95.80008@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:42433 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030259AbWGaRTV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jul 2006 13:19:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>

[PATCH 1/4] fusion: fibre channel: add additional fc transport attributes
[PATCH 2/4] fusion: fibre channel: properly wait for firmware target discovery to complete
[PATCH 3/4] fusion: fibre channel: correct out of order event processing
[PATCH 4/4] fusion: fibre channel: don't sync cache if remote port deleted

Generated against 2.6.18-rc2-scsi-rc-fixes.

Patches are standalone, but their application may be noisy if not
applied in the specified order.

Mike

