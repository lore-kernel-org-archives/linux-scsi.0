From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Fri, 10 May 2013 11:27:10 -0400
Message-ID: <yq1fvxudfe9.fsf@sermon.lab.mkp.net>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net>
	<1368189791.3319.31.camel@localhost.localdomain>
	<CAC9+anJ9Y-SnCOK6EOCavTNJwx=xhAbL_X__MsEsL7DroawaJg@mail.gmail.com>
	<yq1k3n6dgy2.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46797 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896Ab3EJP1b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 May 2013 11:27:31 -0400
In-Reply-To: <yq1k3n6dgy2.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Fri, 10 May 2013 10:53:41 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Baruch Even <baruch@ev-en.org>, emilne@redhat.com, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, michaelc@cs.wisc.edu

>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:

Martin> I'm also working on a patch to add some heuristics to avoid the
Martin> HBA and bus resets

Or rather: Defer the HBA and bus resets...

Martin> if I/O is completing successfully on other attached targets. But
Martin> that's an orthogonal issue.

-- 
Martin K. Petersen	Oracle Linux Engineering
