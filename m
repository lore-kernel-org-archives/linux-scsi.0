From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net v9 0/7] cxgb4/cxgbi: misc. fixes for cxgb4i
Date: Thu, 11 Dec 2014 15:04:30 -0500 (EST)
Message-ID: <20141211.150430.1465687238823811699.davem@davemloft.net>
References: <201412111525.sBBFPbfn012920@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <201412111525.sBBFPbfn012920@localhost6.localdomain6>
Sender: netdev-owner@vger.kernel.org
To: kxie@chelsio.com
Cc: linux-scsi@vger.kernel.org, netdev@vger.kernel.org, hariprasad@chelsio.com, anish@chelsio.com, hch@infradead.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu
List-Id: linux-scsi@vger.kernel.org

From: Karen Xie <kxie@chelsio.com>
Date: Thu, 11 Dec 2014 07:25:37 -0800

> This patch set fixes cxgb4i's tx credit calculation and adds handling of
> additional rx message and negative advice types. It also removes the duplicate
> code in cxgb4i to set the outgoing queues of a packet. 

This series does not apply cleanly at all to net-next, it gets many
rejects.
