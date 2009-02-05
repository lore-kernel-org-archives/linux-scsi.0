From: "Karen Xie" <kxie@chelsio.com>
Subject: RE: [PATCH 2.6.29 1/1] cxgb3i - more transmit work-request checks
Date: Thu, 5 Feb 2009 14:41:42 -0800
Message-ID: <8A71B368A89016469F72CD08050AD334045A4C95@maui.asicdesigners.com>
References: <200902032340.n13Neh7e029867@localhost.localdomain> <498B5D7C.6070500@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:26125 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbZBEWlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2009 17:41:17 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Thanks, Mike,

I will re-submit the patch against scsi-rc-fixes. This one was based on
scsi-misc-2.6/linux-2.6-iscsi.

Karen 

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Thursday, February 05, 2009 1:43 PM
To: Karen Xie
Cc: open-iscsi@googlegroups.com; linux-scsi@vger.kernel.org;
James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH 2.6.29 1/1] cxgb3i - more transmit work-request
checks

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
