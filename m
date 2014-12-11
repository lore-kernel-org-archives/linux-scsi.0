From: Anish Bhatt <anish@chelsio.com>
Subject: RE: [PATCH net v9 0/7] cxgb4/cxgbi: misc. fixes for cxgb4i
Date: Thu, 11 Dec 2014 20:24:48 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D8D9AA8E@nice.asicdesigners.com>
References: <201412111525.sBBFPbfn012920@localhost6.localdomain6>,<20141211.150430.1465687238823811699.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:20086 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127AbaLKU0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Dec 2014 15:26:41 -0500
In-Reply-To: <20141211.150430.1465687238823811699.davem@davemloft.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>, Karen Xie <kxie@chelsio.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Hariprasad S <hariprasad@chelsio.com>, "hch@infradead.org" <hch@infradead.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>

> This series does not apply cleanly at all to net-next, it gets many
> rejects.

Hey Dave, this patchset was mostly bugfixes and hence meant for net where it
applies cleanly. not net-next. We can rebase to net-next and send if you're still
 willing to take it before net-next closes.
-Anish