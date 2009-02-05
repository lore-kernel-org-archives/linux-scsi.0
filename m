From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2.6.29 1/1] cxgb3i - more transmit work-request checks
Date: Thu, 05 Feb 2009 15:43:24 -0600
Message-ID: <498B5D7C.6070500@cs.wisc.edu>
References: <200902032340.n13Neh7e029867@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33341 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbZBEVnf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2009 16:43:35 -0500
In-Reply-To: <200902032340.n13Neh7e029867@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Karen Xie wrote:
> [PATCH 2.6.29 1/1] cxgb3i - more transmit work-request checks
> 
> From: Karen Xie <kxie@chelsio.com>
> 
> - added more checkings for transmit work-request.
> - reserve one work-request for credit return.
> - stop queueing up the outgoing pdus if transmit window is full.
> - split the skb cb into tx and rx portion
> 

What kernel was this made against? I think the patch might include some 
changes that already went upstream. You might want to rebase the patch 
against scsi-rc-fixes.
