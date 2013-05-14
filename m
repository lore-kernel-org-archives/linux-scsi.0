From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Tue, 14 May 2013 18:21:15 -0400
Message-ID: <yq138tp9p9g.fsf@sermon.lab.mkp.net>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net>
	<1368189791.3319.31.camel@localhost.localdomain>
	<CAC9+an+UBY3Cbxryn3O0KMVMuwdXBpf9EsVJ08tV=5Y0dpkjdA@mail.gmail.com>
	<1368194460.3319.40.camel@localhost.localdomain>
	<CAC9+anK-E2pok_eU2EdZxgaBY7-68rbj19C7G4w5rhTmZB7vzw@mail.gmail.com>
	<518D55FA.4080302@suse.de>
	<CAC9+anKxnDBYh15uwQQoTUzGZkwUe6wuV=8wf6NUVsC4+_TUgw@mail.gmail.com>
	<51907E45.7010409@suse.de> <5190FB4E.4000900@tributary.com>
	<519100A5.2060509@suse.de> <51910DB0.70009@tributary.com>
	<yq18v3ibp3n.fsf@sermon.lab.mkp.net> <519154AA.5010500@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23202 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758437Ab3ENWVk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 May 2013 18:21:40 -0400
In-Reply-To: <519154AA.5010500@tributary.com> (Jeremy Linton's message of
	"Mon, 13 May 2013 16:01:30 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Baruch Even <baruch@ev-en.org>, emilne <emilne@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, michaelc <michaelc@cs.wisc.edu>

>>>>> "Jeremy" == Jeremy Linton <jlinton@tributary.com> writes:

>> others. We see cases fairly often where a misbehaving target has
>> confused the HBA enough that we can not bring the device back without
>> doing an HBA firmware reset. Despite I/O completing successfully on
>> other targets connected to the same HBA.

Jeremy> 	This would seem to indicate a HBA/driver bug...

Yep. It's not just targets that go bad!


Jeremy> Except that I've seen the linux error recovery cause more
Jeremy> problems than it solves on a fairly regular basis. I would
Jeremy> rather have a solution designed to isolate failures, than one
Jeremy> that makes a lot of mistakes and causes further problems
Jeremy> (sometimes with other machines). I'm pretty convinced that
Jeremy> attempting everything possible to recover a device when the
Jeremy> underlying problem is unknown is a bad strategy.

There is no one size that fits all. Which is why we're taking steps to
make the error recovery parameters tweakable.

-- 
Martin K. Petersen	Oracle Linux Engineering
