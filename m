From: David Wysochanski <davidw@netapp.com>
Subject: Re: reiserfs and SCSI oops seen in 2.6.9-rc2 with local SCSI disk
 IO
Date: Fri, 24 Sep 2004 15:42:44 -0400
Sender: linux-fsdevel-owner@vger.kernel.org
Message-ID: <415478B4.7090208@netapp.com>
References: <4154372C.7070506@netapp.com> <20040924193942.GA17460@ip68-4-98-123.oc.oc.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20040924193942.GA17460@ip68-4-98-123.oc.oc.cox.net>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Barry K. Nathan wrote:
> On Fri, Sep 24, 2004 at 11:03:08AM -0400, David Wysochanski wrote:
>  > I can reproduce this pretty easily with local disk.
> [snip]
> 
> Make absolutely very very sure that you are *NOT* using SELinux --
> reiserfs and SELinux do NOT get along right now (this is a known
> problem). If you try to use the two together, you'll almost certainly
> get freezes and oopses.
> 
Nope - here's my /proc/cmdline:
root=0802 vga=0x314 selinux=0 splash=silent desktop resume=/dev/sda1 showopts console=tty0 console=ttyS0,9600n8 nmi_watchdog=1


> If you're seeing this type of problem even without SELinux, that's
> interesting...
> 
> -Barry K. Nathan <barryn@pobox.com>
> 


