From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] cxgb3i: zero out reserved or un-used cpl message fields
Date: Fri, 18 Jun 2010 18:03:59 -0500
Message-ID: <4C1BFB5F.6090009@cs.wisc.edu>
References: <201006170010.o5H0AbuU023969@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37468 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab0FRXBg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2010 19:01:36 -0400
In-Reply-To: <201006170010.o5H0AbuU023969@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kxie@chelsio.com
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, rranjan@chelsio.com, James.Bottomley@HansenPartnership.com

On 06/16/2010 07:10 PM, kxie@chelsio.com wrote:
> [PATCH] cxgb3i: zero out reserved or un-used fields.
>
> From: Karen Xie<kxie@chelsio.com>
>
> Zero out the reserved or un-used CPL message fields to prevent any garbage
> value.
>
> Signed-off-by: Karen Xie<kxie@chelsio.com>


Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
