From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] BNX2I: Removed the individual PCI DEVICE ID checking
Date: Wed, 24 Oct 2012 02:02:26 -0500
Message-ID: <50879282.9080608@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1350347497-20965-1-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43501 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757835Ab2JXHCh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2012 03:02:37 -0400
In-Reply-To: <1350347497-20965-1-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Eddie Wai <eddie.wai@broadcom.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 10/15/2012 07:31 PM, Eddie Wai wrote:
> Removed the individual PCI DEVICE ID checking inside bnx2i.  The device
> type can easily be read from the corresponding cnic->flags.  This will
> free bnx2i from having to get updated for every new device ID that gets
> added.
> 
> Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
> Acked-by: Michael Chan <mchan@broadcom.com>

Looks ok.

Reviewd-by: Mike Christie <michaelc@cs.wisc.edu>
