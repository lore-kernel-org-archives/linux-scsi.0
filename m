From: "NeilBrown" <neilb@suse.de>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out
     of the 'queue' sysfs directory.
Date: Fri, 26 Jun 2009 23:23:17 +1000 (EST)
Message-ID: <f0d53a7338e1be4e7bdcbe09223c6f73.squirrel@neil.brown.name>
References: <19010.62951.886231.96622@notabene.brown>
    <yq11vp8spxo.fsf@sermon.lab.mkp.net>
    <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
    <20090625194015.GB31415@kernel.dk>
    <19012.49673.454853.975682@notabene.brown>
    <20090626125037.GO23611@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090626125037.GO23611@kernel.dk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, June 26, 2009 10:50 pm, Jens Axboe wrote:
> On Fri, Jun 26 2009, Neil Brown wrote:
>> Every block device has a 'gendisk' (aka generic disk).
>> Every block device also (currently) has a request_queue.
>
> I don't know why you keep saying currently. It has always had a queue,
> and I don't see a good reason why that should change for "special" block
> devices like md/dm/loop/whatnot.

I say "currently" because I'm planning to create patches to make it
optional, and I want to get you used to the idea :-)

And md/dm/loop/whatnot are not "special" block devices, any more than
scsi/ide are "special" block devices.  They are all just block devices.
They use different mechanisms, but each is just as valid as the other.

The current code makes 'struct request' based block devices in to
first-class citizens, and all the rest are second class (having to
tag our data structures on ->queue data and/or ->private_data).

I just want all block devices to be equal.

NeilBrown

