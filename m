From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 04/14] scsi: Move retries check
Date: Thu, 04 Sep 2008 13:27:26 -0500
Message-ID: <1220552846.3276.54.camel@localhost.localdomain>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
	 <1220371543-15099-5-git-send-email-andmike@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38363 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753506AbYIDS12 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2008 14:27:28 -0400
In-Reply-To: <1220371543-15099-5-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

On Tue, 2008-09-02 at 09:05 -0700, Mike Anderson wrote:
> Move retries check to scsi_queue_insert.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>

Could you clarify the signoff chain on this, please?  It implies that
the patch originated with Mike, but there's no From: for him.

If it's his patch, it needs a From:

If it's your patch, your signoff needs to be first, and his needs to
become an acked-by.

James


