From: brian.auld@adic.com
Subject: Qlogic FC driver(s)
Date: Mon, 5 May 2003 10:56:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <995FF289C9D69747A09E42992644595405B2372F@penguin.adic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [63.81.117.28] ([63.81.117.28]:11205 "EHLO penguin.adic.com")
	by vger.kernel.org with ESMTP id S261161AbTEERsh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2003 13:48:37 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

Can someone in the 'know' comment on the differences/background as to why there is a Qlogic Fibre Channel driver in the kernel tree and a separate driver released by qlogic. 

Is one preferable over the other?

I'm doing some iSCSI target driver work. I have an FC target driver as a reference that was superimposed on top of the qlogic intitiator driver found in the kernel tree (as opposed to glogic). I want to make sure this base driver (kernel tree vs. qlogic) is the preferred choice before proceeding. 

Cheers,

-- Brian
