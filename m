From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: Why /dev/sdc1 doesn't show up...
Date: Mon, 18 Nov 2002 16:08:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0211181607120.13381-100000@home.transmeta.com>
References: <20021118235221.637162C456@lists.samba.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20021118235221.637162C456@lists.samba.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alexander Viro <viro@math.psu.edu>, Doug Ledford <dledford@redhat.com>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Tue, 19 Nov 2002, Rusty Russell wrote:
> 
> See other posting.  This is a fundamental design decision, and it's
> not changing.  Sorry.

Rusty, you take that approach, and the module code flies out of the 
kernel. 

The block device code (and a lot of other code) has been there happily 
forever. And not breaking drivers was part of the module loader rule. Now 
you seem to say that drivers should be broken een if they are perfectly 
fine and do not have any races as is.

If so, then bye bye new module loader.

		Linus
