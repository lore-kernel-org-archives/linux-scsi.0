From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 5244] New: HW RAID1 detected as zero size dr
 ive
Date: Wed, 14 Sep 2005 14:01:49 -0700
Message-ID: <20050914140149.69dbb71c.akpm@osdl.org>
References: <0E3FA95632D6D047BA649F95DAB60E5703662B35@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:5519 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932755AbVINVBz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 17:01:55 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703662B35@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@engenio.com>
Cc: linux-scsi@vger.kernel.org, Sreenivas.Bagalkote@engenio.com, bugme-daemon@kernel-bugs.osdl.org

"Ju, Seokmann" <Seokmann.Ju@engenio.com> wrote:
>
> On Wednesday, September 14, 2005 3:36 PM, Andrew Morton wrote:
> > It's unusual to get a panic with no messages which explain 
> > the reason for
> > the panic.  We'd need to get additional info about that panic 
> > to proceed
> > any further.
> Here, I've attached the message displayed when panic, below.
> Please let me know for any clues.
> ---
> Uncompressing linux... Ok, booting the kernel
> Ibm-acpi: ec object not found
> Red Hat nash version 4.2.1.3 starting
> File descriptor 3 left open.
>   Reading all physical volumes.
>   This may take a while...
>   Found volume group "VolGroup00" using metadata type lvm2
> File descriptor 3 left open.
>   2 logical volume(s) in volume group "VolGroup00" now active
>   Enforcing mode requested but no policy loaded. Halting now.
> Kernel panic - not syncing: Attempted to kill init!

It's always a good idea to stick an error message into google.  First link:
http://forums.fedoraforum.org/archive/index.php/t-1325.html

As to why this happened: dunno.  Please send me your .config and details on
your distro and I'll bug the SELinux guys, thanks.

