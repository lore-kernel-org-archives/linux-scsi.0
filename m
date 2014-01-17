From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: bio_integrity_verify() bug causing READ verify to be silently skipped
Date: Fri, 17 Jan 2014 16:58:40 -0500
Message-ID: <yq1ha92uv73.fsf@sermon.lab.mkp.net>
References: <1387858826.5567.236.camel@haakon3.risingtidesystems.com>
	<yq1sit4zv23.fsf@sermon.lab.mkp.net>
	<1389936047.5567.721.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1389936047.5567.721.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Thu, 16 Jan 2014 21:20:47 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, kmo@daterainc.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

>> That breaks partial completion, though. I'll take a look at Kent's
>> changes...

nab> Ping..?  Any updates on a proper bugfix for this..?

I did put your patch in my queue and have been working on a fix for the
partial completion case. The latter requires a bit of massaging that
interferes with other pending changes.

Given that your patch does address a valid issue I'm OK with Jens
putting it in as is. I'll build upon it for my changes.

-- 
Martin K. Petersen	Oracle Linux Engineering
