From: "J.A. Magallon" <jamagallon@able.es>
Subject: Re: libata update posted
Date: Sat, 13 Sep 2003 23:13:32 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030913211332.GC3478@werewolf.able.es>
References: <3F628DC7.3040308@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3F628DC7.3040308@pobox.com>; from jgarzik@pobox.com on Sat, Sep 13, 2003 at 05:23:51 +0200
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 09.13, Jeff Garzik wrote:
> Just some minor updates.  The main one is that ATA software reset is now 
> considered reliable, so it is now the default. 
> Execute-Device-Diagnostic bus reset method remains in place and can be 
> easily re-enabled with a flag.
> 
> libata has also moved (slightly) to a new home:
> ftp://ftp.kernel.org/pub/linux/kernel/people/jgarzik/libata/
> 
> The latest libata patches for 2.4.x and 2.6.x were uploaded to this URL, 
> and future patches will appear in the same location.
> 
> Look for more updates this weekend, including bug fixes from Dell and 
> Red Hat, and better MMIO support.  And maybe a special surprise.  :)
> 

Any user documentation, like modules names and how to make it work ?
I could write the Configure.help entries.
I suppose you load the PIIX/VIA modules and you have one other scsi
bus.

Any pointer ?

Just adding it to -jam before publishing pre4-jam1.

-- 
J.A. Magallon <jamagallon@able.es>      \                 Software is like sex:
werewolf.able.es                         \           It's better when it's free
Mandrake Linux release 9.2 (Cooker) for i586
Linux 2.4.23-pre4-jam1 (gcc 3.3.1 (Mandrake Linux 9.2 3.3.1-2mdk))
