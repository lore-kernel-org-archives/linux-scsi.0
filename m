From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Fix a bdi reregistration race, v2
Date: Mon, 30 Nov 2015 19:57:35 -0500
Message-ID: <yq1610jf0jk.fsf@sermon.lab.mkp.net>
References: <564F9AFF.3050605@sandisk.com>
	<20151124231331.GA25591@infradead.org> <5654F169.6070000@sandisk.com>
	<20151125084744.GA16429@infradead.org> <5655CCC0.9010107@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <5655CCC0.9010107@sandisk.com> (Bart Van Assche's message of
	"Wed, 25 Nov 2015 06:59:12 -0800")
Sender: owner-linux-mm@kvack.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>, Aaro Koskinen <aaro.koskinen@iki.fi>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-mm@kvack.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart,

Bart> This race is hard to trigger. I can trigger it by repeatedly
Bart> removing and re-adding SRP SCSI devices. Enabling debug options
Bart> like SLUB debugging and kmemleak helps. I think that is because
Bart> these debug options slow down the SCSI device removal code and
Bart> thereby increase the chance that this race is triggered.

Any updates on this? Your updated patch has no reviews.

Should I just revert the original patch for 4.4?

-- 
Martin K. Petersen	Oracle Linux Engineering

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
