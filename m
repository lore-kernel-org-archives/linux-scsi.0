From: Jens Axboe <axboe@fb.com>
Subject: Re: split scsi passthrough fields out of struct request
	V2
Date: Thu, 26 Jan 2017 12:01:43 -0700
Message-ID: <ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485455329.2540.7.camel@sandisk.com>
	<e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
	<1485456745.2540.9.camel@sandisk.com>
	<db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
	<20170126185924.GA25289@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170126185924.GA25289@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "hch@lst.de" <hch@lst.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

On 01/26/2017 11:59 AM, hch@lst.de wrote:
> On Thu, Jan 26, 2017 at 11:57:36AM -0700, Jens Axboe wrote:
>> It's against my for-4.11/block, which you were running under Christoph's
>> patches. Maybe he's using an older version? In any case, should be
>> pretty trivial for you to hand apply. Just ensure that .flags is set to
>> 0 for the common cases, and inherit 'flags' when it is passed in.
> 
> No, the flush op cleanups you asked for last round create a conflict
> with your patch.  They should be trivial to fix, though.

Ah, makes sense. And yes, as I said, should be trivial to hand apply the
hunk that does fail.

-- 
Jens Axboe
