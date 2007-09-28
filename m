From: Douglas Gilbert <dougg@torque.net>
Subject: initiator+target port attributes by transport: sam4r13
Date: Fri, 28 Sep 2007 19:03:13 -0400
Message-ID: <46FD8831.7070207@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33183 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbXI1XDW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2007 19:03:22 -0400
Received: from ip-40.58.99.216.dsl-cust.ca.inter.net ([216.99.58.40] helo=rink.bingwo.ca)
	by pentafluge.infradead.org with esmtpsa (Exim 4.63 #1 (Red Hat Linux))
	id 1IbOrh-0001Xh-K7
	for linux-scsi@vger.kernel.org; Sat, 29 Sep 2007 00:03:21 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

A new draft of SAM-4 was released yesterday and Annex B
has been added. It tabulates various attributes (e.g. maximums)
for 5 modern SCSI transports. [SPI has dropped out of both
Annex A and B.] See:
http://www.t10.org/ftp/t10/drafts/sam4/sam4r13.pdf

That should be a useful design tool.
Strangely iSCSI supports cdb lengths of 65550 bytes!

Doug Gilbert
