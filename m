From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2.6.29-rc] iscsi - add offset and count to alloc_pdu()
Date: Wed, 11 Feb 2009 13:57:21 -0600
Message-ID: <49932DA1.8030704@cs.wisc.edu>
References: <200902110301.n1B31q5M002101@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55547 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZBKT5g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2009 14:57:36 -0500
In-Reply-To: <200902110301.n1B31q5M002101@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: linux-scsi@vger.kernel.org, kxie@chelsio.com, James.Bottomley@HansenPartnership.com

Karen Xie wrote:
> [PATCH 2.6.29-rc] iscsi - add offset and count to alloc_pdu().
> 
> From: Karen Xie <kxie@chelsio.com>
> 
> Hi, Mike,
> 
> I looked through libiscsi.c, libiscsi_tcp.c and iscsi_tcp.c. It does seem to be a little messy to merge the two functions. Especially the BHS is constructed after pdu_alloc(), and iscsi_tcp uses the BHS fields in init_pdu(). 
> 
> So I only added the offset and count as additional parameters to alloc_pdu(). So that the pdu payload is known at the time of pdu memory allocation.
> 

Ehhhhhh, yeah it is workable. Give me a day to check this out more. It 
makes the api akward because we get the data offset and len, but not the 
header. Let me see if I can build on your patch.

Thanks.
