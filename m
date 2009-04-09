From: Jes Sorensen <jes@sgi.com>
Subject: Re: [PATCH 0/2] qla1280: driver clean up, error recovery rewrite
Date: Thu, 09 Apr 2009 10:20:32 +0200
Message-ID: <49DDAFD0.1060007@sgi.com>
References: <49DCFBF6.8050007@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:45190 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755981AbZDIIUe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Apr 2009 04:20:34 -0400
In-Reply-To: <49DCFBF6.8050007@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jeremy Higdon <jeremy@sgi.com>

Michael Reed wrote:
> The first of the following two patches contains the removal
> of some unneeded, inactive and unused code, some trivial
> corrections to comments and a printk, and the return of a
> proper status in qla1280_queuecommand.  No fundamental logic
> changes are made.
> 
> The second of the two patches reworks driver error recovery.
> The driver now waits for the scsi commands associated with a
> particular error recovery step to be returned to the mid-layer,
> and returns the appropriate SUCCESS or FAILED status.  Removes
> unneeded polling of chip for interrupts.
> 
> This patch also bumps the driver version number.
> 
> These patches apply to linux-2.6.30-rc1.
> 
> Signed-off-by: Michael Reed <mdr@sgi.com>

Hi Mike,

Great work!

Acked-by: Jes Sorensen <jes@sgi.com>

Cheers,
Jes

