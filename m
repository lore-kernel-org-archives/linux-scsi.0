From: kxie@chelsio.com
Subject: [PATCH net 0/5] cxgb4/cxgbi: misc. fixes for cxgb4i
Date: Mon, 08 Dec 2014 00:09:05 -0800
Message-ID: <201412080809.sB88953V029835@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:19189 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaLHILm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Dec 2014 03:11:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, netdev@vger.kernel.org
Cc: kxie@chelsio.com, hariprasad@chelsio.com, anish@chelsio.com, hch@infradead.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, davem@davemloft.net

[PATCH net 0/5] cxgb4/cxgbi: misc. fixes for cxgb4i

This patch set fixes cxgb4i's tx credit calculation and adds handling of additional rx messages and types of negative advice. It also removes the duplicate code in cxgb4i to set the outgoing queues of a packet. 

Karen Xie (5):
cxgb4i: check if wr header is required when calculating tx credit
cxgb4/cxgb4i: set max. outgoing pdu length in the f/w
cxgb4i: handle non pdu-aligned rx data and additional types of negative advice 
cxgb4i: use cxgb4's set_wr_txq() for setting outgoing queues
libcxgbi: fix the debug print accessing skb after it is freed

Sending to net as the fixes are mostly in the network area and it touches cxgb4's header file (t4fw_api.h).
