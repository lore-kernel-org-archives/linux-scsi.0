From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: Several Misc SCSI updates...
Date: Sun, 17 Nov 2002 13:40:19 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0211171338570.12975-100000@home.transmeta.com>
References: <20021117203823.GF3280@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021117203823.GF3280@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>


On Sun, 17 Nov 2002, Doug Ledford wrote:
> 
> Won't work.  module->live is what Rusty uses to indicate that the module 
> is in the process of unloading, which is when we *do* want the attempt to 
> module_get() to fail.

That's fine, as long as "module_get()" is the only thing that cares. Just 
make it go "live" early as you indicate, and everybody should be happy. I 
certainly agree that it should be illegal to do more module_get()'s once 
we've already started unloading..

		Linus

