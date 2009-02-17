From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2 1/6 2.6.29-rc] cxgb3i - transmit work-request fixes
Date: Tue, 17 Feb 2009 15:15:20 -0600
Message-ID: <499B28E8.8070801@cs.wisc.edu>
References: <200902140538.n1E5ciEH014325@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53811 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbZBQVPb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 16:15:31 -0500
In-Reply-To: <200902140538.n1E5ciEH014325@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Karen Xie wrote:
> [PATCH v2 1/6 2.6.29-rc] cxgb3i - transmit work-request fixes
> 
> From: Karen Xie <kxie@chelsio.com>
> 
> - resize the work-request credit array to be based on skb's MAX_SKB_FRAGS.
> - split the skb cb into tx and rx portion
> - increase the default transmit window to 128K.
> - stop queueing up the outgoing pdus if transmit window is full.
> 
> Signed-off-by: Karen Xie <kxie@chelsio.com>

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
