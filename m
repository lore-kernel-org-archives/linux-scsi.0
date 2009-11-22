From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH 1/4] block: Allow devices to indicate whether discarded
 blocks are zeroed
Date: Sat, 21 Nov 2009 21:43:15 -0500
Message-ID: <4B08A543.909@rtr.ca>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com> <1258771524-26673-2-git-send-email-martin.petersen@oracle.com> <20091121101356.GA21716@infradead.org> <20091121195802.GC8502@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20091121195802.GC8502@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Sat, Nov 21, 2009 at 05:13:56AM -0500, Christoph Hellwig wrote:
>> On Fri, Nov 20, 2009 at 09:45:21PM -0500, Martin K. Petersen wrote:
>>> The discard ioctl is used by mkfs utilities to clear a block device
>>> prior to putting metadata down.  However, not all devices return zeroed
>>> blocks after a discard.  Some drives return stale data, potentially
>>> containing old superblocks.  It is therefore important to know whether
>>> discarded blocks are properly zeroed.
>> At least for mkfs.xfs we make sure to still zero the important areas
>> after the TRIM ioctl anyway.
> 
> Could you change that to zero _before_ the TRIM?
..


Hopefully not for the drives that *don't* guarantee zeros after TRIM.
Eg. most existing ones, including all of the Indilinx chipset drives.

Cheers

