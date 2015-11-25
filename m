From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Fix a bdi reregistration race, v2
Date: Wed, 25 Nov 2015 06:59:12 -0800
Message-ID: <5655CCC0.9010107@sandisk.com>
References: <564F9AFF.3050605@sandisk.com>
 <20151124231331.GA25591@infradead.org> <5654F169.6070000@sandisk.com>
 <20151125084744.GA16429@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20151125084744.GA16429@infradead.org>
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>, Aaro Koskinen <aaro.koskinen@iki.fi>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-mm@kvack.org
List-Id: linux-scsi@vger.kernel.org

On 11/25/15 00:47, Christoph Hellwig wrote:
> But what I really wanted to ask for is what your reproducer looks like.

Hello Christoph,

This race is hard to trigger. I can trigger it by repeatedly removing 
and re-adding SRP SCSI devices. Enabling debug options like SLUB 
debugging and kmemleak helps. I think that is because these debug 
options slow down the SCSI device removal code and thereby increase the 
chance that this race is triggered.

Bart.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
