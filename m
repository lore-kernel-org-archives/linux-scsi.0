From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Fix a bdi reregistration race, v2
Date: Fri, 20 Nov 2015 14:55:45 -0800
Message-ID: <564FA4F1.5000108@sandisk.com>
References: <564F9AFF.3050605@sandisk.com>
 <20151120224350.GJ18138@blackmetal.musicnaut.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20151120224350.GJ18138@blackmetal.musicnaut.iki.fi>
Sender: owner-linux-mm@kvack.org
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: James Bottomley <jbottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
List-Id: linux-scsi@vger.kernel.org

On 11/20/2015 02:44 PM, Aaro Koskinen wrote:
> I think you should squash the revert of v1 into this patch, and then
> document the crash the original patch caused and how this new patch is
> fixing that.

Hello Aaro,

I'd like to know the opinion of the SCSI maintainers about this. It's 
not impossible that they would prefer to submit the revert to Linus 
quickly and only send the reworked fix to Linus during the v4.5 merge 
window.

Bart.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
