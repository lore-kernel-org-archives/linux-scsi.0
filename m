From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 25 Mar 2008 23:04:49 -0700
Message-ID: <47E9E781.4000901@zytor.com>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca> <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca> <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca> <20080325192515.GA24234@suse.de> <47E99A02.7040903@rtr.ca> <47E99EBE.7010708@gmail.com> <20080326033804.GA27925@suse.de> <47E9D017.5080305@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754078AbYCZGFk@vger.kernel.org>
In-Reply-To: <47E9D017.5080305@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Mark Lord <lkml@rtr.ca>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> 
>> Since when is the major:minor view of devices the "standard" one that
>> userspace uses?  Last I looked, userspace uses symlinks and lots of
>> other ways of directly accessing block devices in /dev/, and does not
>> rely on major:minor.
> 
> The fact that major:minor is the unique identifier of a device makes it
> a bit special compared to other names on filesystem.
> 

In particular, stat() and friends returns the device number, not a 
device name.

	-hpa
