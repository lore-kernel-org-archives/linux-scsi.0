From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: RFC: 512e ZBC host-managed disks
Date: Thu, 12 Jan 2017 10:02:55 -0500
Message-ID: <x49eg08codc.fsf@segfault.boston.devel.redhat.com>
References: <38404478-7b9a-35ed-8148-81a05bd01ac8@wdc.com>
        <20170112082048.GA8276@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170112082048.GA8276@lst.de> (Christoph Hellwig's message of
        "Thu, 12 Jan 2017 09:20:48 +0100")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> On Thu, Jan 12, 2017 at 05:13:52PM +0900, Damien Le Moal wrote:
>> (3) Any other idea ?
>
> Do nothing and ignore the problem.  This whole idea so braindead that
> the person coming up with the T10 language should be shot.  Either a device
> has 511 logical sectors or 4k but not this crazy mix.
>
> And make sure no one ships such a piece of crap because we are hell
> not going to support it.

Agreed.  This is insane.

-Jeff
