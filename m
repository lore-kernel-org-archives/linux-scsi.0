From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Fri, 10 May 2013 10:53:41 -0400
Message-ID: <yq1k3n6dgy2.fsf@sermon.lab.mkp.net>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net>
	<1368189791.3319.31.camel@localhost.localdomain>
	<CAC9+anJ9Y-SnCOK6EOCavTNJwx=xhAbL_X__MsEsL7DroawaJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19305 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab3EJOyC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 May 2013 10:54:02 -0400
In-Reply-To: <CAC9+anJ9Y-SnCOK6EOCavTNJwx=xhAbL_X__MsEsL7DroawaJg@mail.gmail.com>
	(Baruch Even's message of "Fri, 10 May 2013 16:20:52 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baruch Even <baruch@ev-en.org>
Cc: emilne@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, michaelc@cs.wisc.edu

>>>>> "Baruch" == Baruch Even <baruch@ev-en.org> writes:

Baruch> Actually reducing the timeouts is probably not a good approach
Baruch> since it will cause the host to take a more radical approach
Baruch> without waiting sufficiently for a potential recovery.

Reducing the eh timeout is a requirement in many clustered setups. We've
been shipping a predecessor to this patch in our kernels for a long
time.


Baruch> In addition the more radical error handlings such as host reset
Baruch> will destroy other paths for completely unrelated devices/links,
Baruch> from my experience a host reset is usually not required and the
Baruch> Linux kernel currently reaches to this big hammer too fast.

I'm also working on a patch to add some heuristics to avoid the HBA and
bus resets if I/O is completing successfully on other attached
targets. But that's an orthogonal issue.

-- 
Martin K. Petersen	Oracle Linux Engineering
