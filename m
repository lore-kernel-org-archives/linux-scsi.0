From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: can't access LUN >2TB with aic7xxx, Infortrend EonStor and
	2.6.31-rc1
Date: Mon, 29 Jun 2009 07:47:39 -0600
Message-ID: <20090629134739.GO5480@parisc-linux.org>
References: <20090629130835.GA3657@mother.pipebreaker.pl> <20090629133431.GM5480@parisc-linux.org> <c268e4660906290640k3364aeaey30d37b884a2ce1c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36016 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZF2Nrg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 09:47:36 -0400
Content-Disposition: inline
In-Reply-To: <c268e4660906290640k3364aeaey30d37b884a2ce1c6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Tomasz Torcz <tomek@pipebreaker.pl>, linux-scsi@vger.kernel.org

On Mon, Jun 29, 2009 at 06:40:21AM -0700, Drew wrote:
> > You could also go for a configuration fix where you reconfigure the array
> > with LUNs below 2TB and then use MD or DM to stitch them back together
> > into a single device.
> 
> Would you not also have to partition the drive using GPT partitions?
> LVM aside, I thought any partition over 2TB had to be GPT.

If you choose to partition the device at all -- I often create filesystems
directly on the block device.  Regardless, you need the SCSI command
to be able to get to the device before you can start worrying about
partitioning schemes.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
