From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: [dm-devel] Re: [PATCH 1/3] block: add alt_size
Date: Mon, 11 May 2009 09:45:34 -0400
Message-ID: <20090511134534.GA32678@mars.virtualiron.com>
References: <1241828002-12742-1-git-send-email-tj@kernel.org> <1241828002-12742-2-git-send-email-tj@kernel.org> <ac3eb2510905090645u5e482ffcu4b3ddc26e81247e6@mail.gmail.com> <4A058D5C.6030206@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A058D5C.6030206@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, tj@kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, jeff@garzik.org, linux-scsi@vger.kernel.org, Mauelshagen@redhat.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

.. snip ..
> > Also, values with magic block counts, while there is no way to get the
> > blocksize with the same interface, are pretty weird. I think the
> > current "size" attribute is just a bug.
> 
> Logical block size is fixed at 512 bytes.  Offset and size are always
> represented in multiples of 512 bytes and only get converted to
> hardware block size in the lld.

That interpretation is at odds with the work that Martin Peterson is
doing with the 4K support. In the e-mail titled: "Re: [PATCH 4 of 8] sd:
Physical block size and alignment support",
Message-ID:<yq1ab67b51p.fsf@sermon.lab.mkp.net> he says:

"
	Konrad> about what a 'logical block', and 'physical block' is
	Konrad> vs. 'hardware sector' ?

	Well, another item on my todo list is to kill the notion of hardware
	sector completely.  The protocols have been referring to logical blocks
	for ages.

	It hasn't been a big problem until now because logical block size has
	been equal to the hardware sector size.  That's no longer a valid
	assumption.
"

Are the ATA/SCSI/etc specs at odds with each other about this?
