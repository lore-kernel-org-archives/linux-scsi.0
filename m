From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [SCSI] fix media change events for polled devices
Date: Fri, 21 Mar 2008 16:39:27 -0400
Message-ID: <47E41CFF.9000303@garzik.org>
References: <200803211559.m2LFxPi6017869@hera.kernel.org> <47E3EC67.4050404@garzik.org> <alpine.LFD.1.00.0803211031010.3020@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:45083 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756832AbYCUUj3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 16:39:29 -0400
In-Reply-To: <alpine.LFD.1.00.0803211031010.3020@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 21 Mar 2008, Jeff Garzik wrote:
>> And that is the fix -- initialize supported_events according to sr/sd's needs,
>> and revert this change (4d1566ed2100d074ccc654e5cf2e44cdea3a01d0) as obviously
>> broken.
> 
> Patches, please? I can do the revert, but the patch to supported_events 
> and the testing, please?

James was the one who wrote the incomplete/broken changes,

	commit 285e9670d91cdeb6b6693729950339cb45410fdc
	Author: Kay Sievers <kay.sievers@vrfy.org>
	Date:   Tue Aug 14 14:10:39 2007 +0200

	    [SCSI] sr,sd: send media state change modification events
[...]
	[jejb: modified for new event API]

so I'm hoping he will fix it up.

I'll send a patch if he doesn't, though.

	Jeff


