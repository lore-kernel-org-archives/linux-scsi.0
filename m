From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: MPTSAS problems in 2.6.26-rc2-mm1
Date: Wed, 28 May 2008 09:47:43 -0500
Message-ID: <1211986063.3445.18.camel@localhost.localdomain>
References: <483D28C5.4060406@linux.vnet.ibm.com>
	 <1211967958.12349.65.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34134 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909AbYE1Orr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2008 10:47:47 -0400
In-Reply-To: <1211967958.12349.65.camel@twins>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: balbir@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux kernel mailing list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>

On Wed, 2008-05-28 at 11:45 +0200, Peter Zijlstra wrote:
> On Wed, 2008-05-28 at 15:11 +0530, Balbir Singh wrote:
> > I have 2.6.26-rc2-mm1 with Rik's splitvm patches. While booting the kernel, I
> > ran into the following. I searched my email quickly to see that no one else has
> > reported this problem. Lockdep seems to be complaining about the same lock being
> > held at the same location (the message is a bit confusing to me).
> 
> looks like device_add() recursing - most likely with a different device
> though.

This is another instance of a problem being caused by semaphore to mutex
conversion in struct class;

There's another thread on this here:

http://marc.info/?t=121074904600001

James



