From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 0/4] cxgbi: driver update
Date: Fri, 10 Apr 2015 13:57:09 -0700
Message-ID: <201504102057.t3AKv9xR028741@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:19586 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbbDJVAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Apr 2015 17:00:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kxie@chelsio.com, hch@infradead.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

This patch set contains fixes and updates for the cxgbi drivers. It updates 
the driver copyrights and versions, added logic to adjust the send/recv 
window based on the link speed and the initial sequence number.

Karen Xie (4):
cxgbi: use per-connection link-speed dependent send/recv windows
cxgbi: update copyright to 2015
cxgbi: update driver versions
cxgb4i: added setting of the initial sequence number
