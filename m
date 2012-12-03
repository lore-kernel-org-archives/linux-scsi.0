From: Chris Friesen <chris.friesen@genband.com>
Subject: Re: getting I/O errors in super_written()...any ideas what would
 cause this?
Date: Mon, 03 Dec 2012 15:36:39 -0600
Message-ID: <50BD1B67.7090606@genband.com>
References: <8134827.27.1354128708501.JavaMail.root@zimbra> <50B67230.4080602@genband.com> <CADNH=7Hv2RgBv=0Xia=yMyzKmgAOgvxJSAKn2arcE7k1x_T4FQ@mail.gmail.com> <50B67417.2020606@genband.com> <50BD09EC.5060705@redhat.com> <50BD0F44.7010808@genband.com> <50BD1127.6090304@redhat.com> <50BD14B1.7000203@genband.com> <50BD17CD.8080206@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <50BD17CD.8080206@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dave Jiang <dave.jiang@intel.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Neil Brown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 12/03/2012 03:21 PM, Dave Jiang wrote:
> On 12/03/2012 02:08 PM, Chris Friesen wrote:
>> On 12/03/2012 02:52 PM, Ric Wheeler wrote:
>>
>>> I jumped into this thread late - can you repost detail on the specific
>>> drive and HBA used here? In any case, it sounds like this is a better
>>> topic for the linux-scsi or linux-ide list where most of the low level
>>> storage people lurk :)
>> Okay, expanding the receiver list. :)
>>
>> To recap:
>>
>> I'm running 2.6.27 with LVM over software RAID 1 over a pair of SAS disks.
>> Disks are WD9001BKHG, controller is Intel C600.
>
> Just curious what driver are you using with the C600. The upstream
> driver for C600 didn't get accepted until 3.0-rc6 and all of the
> outstanding patches weren't accepted until 3.7-rc. So I'd say 3.6 would
> be your best bet until 3.7 is released. Did you attempt a backport of
> the isci driver or using something like an LSI port on 2.6.27? Have you
> verified the issue on a more recent kernel?

We're using a driver provided by the hardware vendor.  It appears to be 
a backport of version 1.0.1 of the isci driver.  We've been using it 
since mid-March or so.

This is an embedded system, so as is all too common in that environment 
upgrading the whole kernel isn't an option since it requires support 
from multiple hardware/software vendors.

Upgrading just the driver might be possible--do you think it's likely as 
a cause for these errors?  The current driver has a binary firmware file 
that it uses--would we keep that with the new driver?

Chris
