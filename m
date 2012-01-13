From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [LSF/MM TOPIC] Copy offload
Date: Fri, 13 Jan 2012 14:25:52 -0500
Message-ID: <yq1ty3zflq7.fsf@sermon.lab.mkp.net>
References: <4F0AC112.2000709@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:54404 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab2AMT0A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2012 14:26:00 -0500
In-Reply-To: <4F0AC112.2000709@suse.de> (Hannes Reinecke's message of "Mon, 09
	Jan 2012 11:27:30 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: lsf-pc@lists.linux-foundation.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> - Backends: Should we concentrate on the new 'XCOPY LITE'
Hannes>   proposal or should we try to implement the original XCOPY
Hannes>   command, too?

I know of very few vendors interested in implementing the original XCOPY
stuff. Only the standards people seem to be excited about it. It's way
too complex, IMHO.

XCOPY lite is a much better fit for how we actually do I/O. So that's
what I'm tracking closely. As we talked about in Prague, I've dabbled a
bit with the design from an I/O stack perspective and it fits nicely.

My gut feeling is that XCOPYv2 might get ratified but companies will
actually end up implementing XCOPY lite. Regardless of whether the lite
proposal gets into the spec or not.

T10 appears to be designing a lot of stuff right now that's an extremely
poor fit for how modern operating systems work. I think we may see a
bigger divergence between what's in the spec and what companies choose
to implement.

-- 
Martin K. Petersen	Oracle Linux Engineering
