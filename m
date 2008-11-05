From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 3/8] zfcp: fix mempool usage for status_read requests
Date: Wed, 05 Nov 2008 12:46:12 -0500
Message-ID: <1225907172.4703.45.camel@localhost.localdomain>
References: <20081104153504.606043000@de.ibm.com>
	 <20081104153627.530433000@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53931 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753229AbYKESlG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2008 13:41:06 -0500
In-Reply-To: <20081104153627.530433000@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>

On Tue, 2008-11-04 at 16:35 +0100, Christof Schmitt wrote:
> plain text document attachment (fix-status-read-alloc.diff)
> From: Christof Schmitt <christof.schmitt@de.ibm.com>
> 
> When allocating fsf requests without qtcb, store the pointer to the
> mempool in the fsf requests for later call to mempool_free. This
> codepath is only used by the status_read requests.
> 
> Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
> Signed-off-by: Swen Schillig <swen@vnet.ibm.com>

I put this one in, but can you explain this last signoff better?  You
sent me the patch, so your signoff should appear last.  If Swen altered
the patch, his signoff should appear before yours (with a small
explanation of the alteration in square brackets).  If he's just
approving it, it should be Acked-by: not Signed-off-by:

James


