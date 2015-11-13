From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv4 1/1] SCSI: hosts: update to use ida_simple for host_no management
Date: Fri, 13 Nov 2015 16:54:43 -0500
Message-ID: <yq1ziyhy38c.fsf@sermon.lab.mkp.net>
References: <cover.1444241058.git.lduncan@suse.com>
	<f89fe3933ae899dc01f2eddd2a0cefac3383cf3c.1444241058.git.lduncan@suse.com>
	<1444830904.2220.28.camel@HansenPartnership.com>
	<561EA018.7020700@suse.com>
	<1444848835.2220.50.camel@HansenPartnership.com>
	<5644BEE1.3010208@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5644BEE1.3010208@suse.com> (Lee Duncan's message of "Thu, 12 Nov
	2015 17:31:29 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Lee" == Lee Duncan <lduncan@suse.com> writes:

>> Well, I'm a bit worried about the loss of a monotonically increasing
>> host number from the debugging perspective.  Right now, if you look
>> at any log, hostX always refers to one and only one incarnation
>> throughout the system lifetime for any given value of X.

That's a feature that I would absolutely hate to lose. I spend a huge
amount of time looking at system logs.

-- 
Martin K. Petersen	Oracle Linux Engineering
