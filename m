From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] cxgb4i: ignore informational act-open-rpl message
Date: Sun, 17 Oct 2010 12:53:12 -0500
Message-ID: <4CBB3808.1030801@cs.wisc.edu>
References: <201010170509.o9H595xq019898@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48338 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756986Ab0JQRqf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Oct 2010 13:46:35 -0400
In-Reply-To: <201010170509.o9H595xq019898@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kxie@chelsio.com
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, rranjan@chelsio.com, James.Bottomley@HansenPartnership.com

On 10/17/2010 12:09 AM, kxie@chelsio.com wrote:
> [PATCH] cxgb4i: ignore informational act-open-rpl message
>
> From: Karen Xie<kxie@chelsio.com>
>
> Ignore active open reply with status negative advice. This is an informational message.
>
> Signed-off-by: Karen Xie<kxie@chelsio.com>


Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
