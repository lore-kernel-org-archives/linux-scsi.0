From: "Edward A. Hildum" <ehildum@mail.arc.nasa.gov>
Subject: sym53c8xx: sym_prepare_nego(): conditions too broad for PPR negotation?
Date: Mon, 22 Aug 2005 12:07:02 -0700
Message-ID: <430A2256.8010007@mail.arc.nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pony2pub.arc.nasa.gov ([128.102.31.42]:28690 "EHLO arc.nasa.gov")
	by vger.kernel.org with ESMTP id S1751326AbVHWCHY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 22:07:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org

In sym-2.2.0, function sym_prepare_nego(), we set up PPR negotiation 
whenever goal->period is less than 10.  goal->period is set to 0 by 
sym_check_goals() if spi_support_sync() is FALSE, so we get PPR 
negotiation for anything that doesn't support synchronous transfers.

Is this what we want?

Ted Hildum
