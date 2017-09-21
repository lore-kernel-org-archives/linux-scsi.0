From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: usb/storage/uas: slab-out-of-bounds in uas_probe
Date: Thu, 21 Sep 2017 18:10:27 +0200
Message-ID: <20170921161027.GB15554@kroah.com>
References: <CAAeHK+xiFr1RW+HkoFhnypcgsnp6DgwzwVZ1pzQdzHeYZU+N5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAeHK+xiFr1RW+HkoFhnypcgsnp6DgwzwVZ1pzQdzHeYZU+N5A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>, USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, LKML <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>, syzkaller <syzkaller@googlegroups.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 21, 2017 at 05:39:05PM +0200, Andrey Konovalov wrote:
> Hi!
> 
> I've got the following report while fuzzing the kernel with syzkaller.
> 
> On commit ebb2c2437d8008d46796902ff390653822af6cc4 (Sep 18).
> 
> The issue occurs when we iterate over interface altsettings, but I
> don't see the driver doing anything wrong. I might be missing
> something, or this might be an issue in USB core altsettings parsing.


Any chance you happen to have the descriptors that you were feeding into
the kernel at this crash?  That might help in figuring out what "went
wrong".

thanks,

greg k-h
