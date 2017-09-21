From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb/storage/uas: slab-out-of-bounds in uas_probe
Date: Thu, 21 Sep 2017 12:50:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1709211156570.1299-100000@iolanthe.rowland.org>
References: <CAAeHK+xiFr1RW+HkoFhnypcgsnp6DgwzwVZ1pzQdzHeYZU+N5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAeHK+xiFr1RW+HkoFhnypcgsnp6DgwzwVZ1pzQdzHeYZU+N5A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Oliver Neukum <oneukum@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, LKML <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>, syzkaller <syzkaller@googlegroups.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 21 Sep 2017, Andrey Konovalov wrote:

> Hi!
> 
> I've got the following report while fuzzing the kernel with syzkaller.
> 
> On commit ebb2c2437d8008d46796902ff390653822af6cc4 (Sep 18).
> 
> The issue occurs when we iterate over interface altsettings, but I
> don't see the driver doing anything wrong. I might be missing
> something, or this might be an issue in USB core altsettings parsing.

My guess is the latter, although I can't see what is going wrong.  Can 
you provide the code that does this?

Alan Stern
