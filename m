From: kxie@chelsio.com
Subject: [PATCH net v2 0/5] cxgb4/cxgbi: misc. fixes for cxgb4i
Date: Mon, 08 Dec 2014 01:58:05 -0800
Message-ID: <201412080958.sB89w5JZ005481@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, netdev@vger.kernel.org
Cc: kxie@chelsio.com, hariprasad@chelsio.com, anish@chelsio.com, hch@infradead.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, davem@davemloft.net
List-Id: linux-scsi@vger.kernel.org

[PATCH net v2 0/5] cxgb4/cxgbi: misc. fixes for cxgb4i

This patch set fixes cxgb4i's tx credit calculation and adds handling of additional rx messages and types of negative advice. It also removes the duplicate code in cxgb4i to set the outgoing queues of a packet. 

Karen Xie (5):
cxgb4i: check if wr header is required when calculating tx credit
cxgb4/cxgb4i: set max. outgoing pdu length in the f/w
cxgb4i: handle non pdu-aligned rx data and additional types of negative advice 
cxgb4i: use cxgb4's set_wr_txq() for setting outgoing queues
libcxgbi: fix the debug print accessing skb after it is freed

Sending to net as the fixes are mostly in the network area and it touches cxgb4's header file (t4fw_api.h).

v2 corrects the "CHECK"s flagged by checkpatch.pl --strict.
