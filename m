From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: add transport class phy reset capability
Date: Fri, 25 Aug 2006 20:19:27 -0500
Message-ID: <1156555167.3462.32.camel@mulgrave.il.steeleye.com>
References: <1156533974.3462.17.camel@mulgrave.il.steeleye.com>
	 <44EF9F63.2030305@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:26314 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751363AbWHZBTb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Aug 2006 21:19:31 -0400
In-Reply-To: <44EF9F63.2030305@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2006-08-25 at 21:09 -0400, Douglas Gilbert wrote:
> The ability to disable a phy (on a HBA or on an expander)
> is also a very useful capability. Does the sas_transport
> give us that capability?

It could ... It's just another parameter to SMP_PHY_CONTROL.  However,
I'm just wiring up the existing functions ... feel free to send patches
if you want new function.

> There is a way to effectively disable a phy on a SAS disk
> as well: use SEND DIAGNOSTIC to send the SAS protocol
> specific diagnostic page to put the disk phy in CJTPAT
> (jitter pattern) generation mode. However unless another
> phy is accessible on that disk to clear that state, a
> power cycle is needed to re-enable a phy in jitter pattern
> generation mode.

That doesn't sound terribly safe ... most SAS cages only connect up one
of the internal ports, so effectively there's no way to terminate this
for most SAS setups.

James

