From: "hch@lst.de" <hch@lst.de>
Subject: Re: split scsi passthrough fields out of struct request V2
Date: Thu, 26 Jan 2017 19:59:24 +0100
Message-ID: <20170126185924.GA25289@lst.de>
References: <1485365126-23210-1-git-send-email-hch@lst.de> <1485455329.2540.7.camel@sandisk.com> <e8f4b084-be66-d5b3-5785-13b80642040f@fb.com> <1485456745.2540.9.camel@sandisk.com> <db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 26, 2017 at 11:57:36AM -0700, Jens Axboe wrote:
> It's against my for-4.11/block, which you were running under Christoph's
> patches. Maybe he's using an older version? In any case, should be
> pretty trivial for you to hand apply. Just ensure that .flags is set to
> 0 for the common cases, and inherit 'flags' when it is passed in.

No, the flush op cleanups you asked for last round create a conflict
with your patch.  They should be trivial to fix, though.
