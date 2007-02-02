From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/2] : definion, code, and use of new SCSI ML host
	status DID_COND_REQUEUE
Date: Fri, 02 Feb 2007 17:18:07 -0600
Message-ID: <1170458287.3380.39.camel@mulgrave.il.steeleye.com>
References: <1170453887.14264.73.camel@egoggin-devd.eng.vmware.com>
	 <1170456892.3380.35.camel@mulgrave.il.steeleye.com>
	 <1170457871.14264.81.camel@egoggin-devd.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:37389 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946155AbXBBXSL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2007 18:18:11 -0500
In-Reply-To: <1170457871.14264.81.camel@egoggin-devd.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Edward Goggin <egoggin@vmware.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com

On Fri, 2007-02-02 at 18:11 -0500, Edward Goggin wrote:
> That solution doesn't work for the RDAC/MPP driver as the BUSY status
> handler retries indefinitely.  We need a solution which works for both a
> bare metal host running RDAC/MPP which for this use case, wants to get
> control over the failed command ASAP and a VMware host which may need to
> retry longer than DID_BUS_BUSY currently allows for.

No it doesn't, not any longer... the mid-layer retries for the command
up to its timeout before failing.  That's the point about questioning
the validity of the original problem.

James


