From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH] Fix a bdi reregistration race, v2
Date: Sat, 21 Nov 2015 00:43:50 +0200
Message-ID: <20151120224350.GJ18138@blackmetal.musicnaut.iki.fi>
References: <564F9AFF.3050605@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <564F9AFF.3050605@sandisk.com>
Sender: owner-linux-mm@kvack.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jbottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-mm@kvack.org
List-Id: linux-scsi@vger.kernel.org

Hi,

I think you should squash the revert of v1 into this patch, and then
document the crash the original patch caused and how this new patch is
fixing that.

A.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
