From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 25 Mar 2008 14:26:45 -0700
Message-ID: <47E96E15.7020105@zytor.com>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca> <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca> <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca> <20080325192515.GA24234@suse.de> <20080325123454.4eba7644.randy.dunlap@oracle.com> <47E96263.9000808@zytor.com> <20080325212032.GA24495@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080325212032.GA24495@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Mark Lord <lkml@rtr.ca>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Greg KH wrote:
> On Tue, Mar 25, 2008 at 01:36:51PM -0700, H. Peter Anvin wrote:
>> Randy Dunlap wrote:
>>>> Come on people, adding symlinks for device major:minor numbers in sysfs
>>>> to save a few 10s of lines of userspace code?  Can things get sillier?
>>>>
>>>> You can add a single udev rule to probably build these in a tree in /dev
>>>> if you really need such a thing...
>>>>
>>>> And what's wrong with your new ioctl recomendation?
>>> Ah, there's some sanity.  :)
>> It's not so much an issue of a few tens of lines of user space code, but 
>> rather the fact that something that should be O(1) is currently O(n).
> 
> "should"?  why?  Is this some new requirement that everyone needs?  I've
> _never_ seen anyone ask for the ability to find sysfs devices by
> major:minor number in O(1) time.  Is this somehow a place where such
> optimization is warranted?

Well, when dealing with shell scripts a O(n) very easily becomes O(n^2). 
  For the stuff that I, personally, do, it's not a big deal, but people 
with large number of disks have serious gripes with our boot times.

	-hpa
