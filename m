From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: How to resurrect offlined SCSI devices?
Date: 26 May 2004 10:11:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085584277.2113.189.camel@mulgrave>
References: <OF8BCC3715.F39A8EBA-ONC1256EA0.00523377-C1256EA0.005351F7@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:36054 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265292AbUEZPLS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 11:11:18 -0400
In-Reply-To: <OF8BCC3715.F39A8EBA-ONC1256EA0.00523377-C1256EA0.005351F7@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-05-26 at 10:04, Martin Peschke3 wrote:
> How does the user know that it is safe?
> What if they just try to bring it online? What is happening in the worst
> case?
> My point is that users probably set the appropriate sys-attribute
> in a "trial and error" fashion, if they think they have got a problem,
> while an lldd might even know better.

The LLD rarely knows why a device was set offline.  The user at least
has the logs to look through.  Use of the state interface is caveat
emptor anyway.

The way it would work in the scenario you outline: some event indicating
that the device is available is to trigger a hotplug which may take the
action to set the device running again.

Setting devices back on line after a failure is a policy decision that
should not be taken by the LLD.

James


