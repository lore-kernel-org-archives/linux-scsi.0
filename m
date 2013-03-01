From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] Final round of SCSI updates for the 3.8+ merge window
Date: Fri, 01 Mar 2013 15:06:59 +0000
Message-ID: <1362150419.2384.29.camel@dabdike.int.hansenpartnership.com>
References: <1362129599.2384.13.camel@dabdike.int.hansenpartnership.com>
	 <5130ACBE.8080300@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59435 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043Ab3CAPHF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Mar 2013 10:07:05 -0500
In-Reply-To: <5130ACBE.8080300@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On Fri, 2013-03-01 at 08:27 -0500, Douglas Gilbert wrote:
> What is the status of the:
>    - scsi: 64-bit LUN support [v2]

It's a big change and too late for this merge window.

>    - SG_SCSI_RESET ioctl: add no_escalate values [v2]

The most recent report says


> The results were "interesting", there are some really
> strange things that happen in some of the LLD error paths. Its obvious
> that
> error injection is not part of testing many of them, and what at first
> glance
> should be a fairly straightforward error can create quite a mess. So
> anyone
> sending any kind of reset (especially without the ESCALATE flag which
> tends to
> isolate the error handling) to the LLD's should be aware that behavior
> between
> them can vary significantly.
> 
So the patch does seem to have dangerous side effects.

James


