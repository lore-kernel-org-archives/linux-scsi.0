From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
Date: Thu, 02 Apr 2009 12:46:02 -0400
Message-ID: <49D4EBCA.4000304@garzik.org>
References: <20090402015455.GA14087@havoc.gtf.org> <49D4AF12.40708@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49D4AF12.40708@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: open-osd mailing-list <osd-dev@open-osd.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> On 04/02/2009 04:54 AM, Jeff Garzik wrote:
>> As I promised in older exofs threads, here is a client for libosd
>> _other_ than exofs.  This block driver exports a single OSD object
>> as a Linux block device.
>>
>> See the comment block at the top of the driver for usage instructions.
>>
>>
>>
>>  drivers/block/Kconfig  |   16 +
>>  drivers/block/Makefile |    1 
>>  drivers/block/osdblk.c |  563 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 580 insertions(+)
>>
> 
> Forwarding to open-osd ml
> 
> Jeff is it OK if I pick up this patch through my tree and will push it
> together with the other pending patches for 2.6.31 Kernel? I intend to

Please don't add it to any repo just yet.  It is still changing rapidly, 
and that would just slow me down, at the moment.

More comments later...

	Jeff



