From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/4] cxgbi: driver update
Date: Mon, 13 Apr 2015 15:26:54 -0500
Message-ID: <552C268E.10001@cs.wisc.edu>
References: <201504102057.t3AKv9xR028741@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38028 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbbDMUbi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Apr 2015 16:31:38 -0400
In-Reply-To: <201504102057.t3AKv9xR028741@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>, linux-scsi@vger.kernel.org
Cc: hch@infradead.org, James.Bottomley@HansenPartnership.com

On 04/10/2015 03:57 PM, Karen Xie wrote:
> This patch set contains fixes and updates for the cxgbi drivers. It updates 
> the driver copyrights and versions, added logic to adjust the send/recv 
> window based on the link speed and the initial sequence number.
> 
> Karen Xie (4):
> cxgbi: use per-connection link-speed dependent send/recv windows
> cxgbi: update copyright to 2015
> cxgbi: update driver versions
> cxgb4i: added setting of the initial sequence number
> 

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
