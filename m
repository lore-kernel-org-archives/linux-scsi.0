From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/2] target refcounting infrastructure fixes for usb
Date: Fri, 07 Mar 2014 13:21:02 +0400
Message-ID: <1394184062.5225.30.camel@dabdike>
References: <1390316319.2182.9.camel@dabdike.int.hansenpartnership.com>
	 <20140306231827.GA5307@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38122 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbaCGJVJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2014 04:21:09 -0500
In-Reply-To: <20140306231827.GA5307@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, USB list <linux-usb@vger.kernel.org>

On Thu, 2014-03-06 at 15:18 -0800, Sarah Sharp wrote:
> Hi James,
> 
> Sorry for the extremely late ack.

That's OK ... my original plan was to send them in the last merge window
even without your ack, but that got a bit derailed, so I'll do it in
this one with.

>   These patches work fine when applied
> against 3.14-rc5, and I can't trigger the oops anymore.  Hans' UAS
> patches are going to be queued for 3.15.  Any chance of these patches
> making it into 3.15 as well?

Yes, the plan is to queue for 3.15 and request a delayed backport to
stable in case any of the extensive logic changes triggers another bug
in the field.

James


