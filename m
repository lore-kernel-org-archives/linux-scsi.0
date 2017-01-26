From: Jens Axboe <axboe@fb.com>
Subject: Re: split scsi passthrough fields out of struct request V2
Date: Thu, 26 Jan 2017 11:57:36 -0700
Message-ID: <db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
 <1485455329.2540.7.camel@sandisk.com>
 <e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
 <1485456745.2540.9.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1485456745.2540.9.camel@sandisk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On 01/26/2017 11:52 AM, Bart Van Assche wrote:
> On Thu, 2017-01-26 at 11:44 -0700, Jens Axboe wrote:
>> I think this may be my bug - does the below help?
> 
> Hello Jens,
> 
> What tree has that patch been generated against? It does not apply
> cleanly on top of Christoph's tree:
> 
> $ git checkout hch-block-pc-refactor
> $ patch -p1 --dry-run -f -s < ~/Re\:_split_scsi_passthrough_fields_out_of_struct_request_V2.mbox
> 1 out of 3 hunks FAILED

It's against my for-4.11/block, which you were running under Christoph's
patches. Maybe he's using an older version? In any case, should be
pretty trivial for you to hand apply. Just ensure that .flags is set to
0 for the common cases, and inherit 'flags' when it is passed in.

-- 
Jens Axboe

