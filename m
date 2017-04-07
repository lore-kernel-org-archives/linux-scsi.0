From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v4 0/6] Avoid that scsi-mq and dm-mq queue processing
 stalls sporadically
Date: Fri, 7 Apr 2017 12:23:54 -0600
Message-ID: <78b80b12-a764-a793-f8a1-7a941dc84ee5@kernel.dk>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/07/2017 12:16 PM, Bart Van Assche wrote:
> Hello Jens,
> 
> The six patches in this patch series fix the queue lockup I reported
> recently on the linux-block mailing list. Please consider these patches
> for inclusion in the upstream kernel.

Some of this we need in 4.11, but not all of it. I can't be applying patches
that "improve scalability" at this point.

4-6 looks like what we want for 4.11, I'll see if those apply directly. Then
we can put 1-3 on top in 4.12, with the others pulled in first.

-- 
Jens Axboe
