From: Olaf Hering <olh@suse.de>
Subject: Re: 2.6.15-git12, slab corruption in ipr
Date: Mon, 30 Jan 2006 19:07:11 +0100
Message-ID: <20060130180711.GA8106@suse.de>
References: <20060117000533.GA27473@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:13224 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S964860AbWA3SHN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 13:07:13 -0500
Content-Disposition: inline
In-Reply-To: <20060117000533.GA27473@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Brian J King <bjking1@us.ibm.com>

 On Tue, Jan 17, Olaf Hering wrote:

> I tested the current Linus tree + a few SuSE patches on a p710. There is
> some slab corruption.  Will check if plain Linus tree gives the same...
> 
> dmesg | grep -wiC9 slab
> sda: Write Protect is off
> sda: Mode Sense: cb 00 00 08
> SCSI device sda: drive cache: write through
> SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
> sda: Write Protect is off
> sda: Mode Sense: cb 00 00 08
> SCSI device sda: drive cache: write through
>  sda: sda1 sda2 sda3 sda4
> sd 0:0:3:0: Attached scsi disk sda
> Slab corruption: start=c000000000431000, len=4096
> d80: c0 00 00 00 00 43 1d 80 c0 00 00 00 00 43 1d 80
>   Vendor: IBM       Model: IC35L036UCDY10-0  Rev: S28G
>   Type:   Direct-Access                      ANSI SCSI revision: 03

I made https://bugzilla.novell.com/show_bug.cgi?id=145459 public.
No idea if this is one bug (mem corruption on ppc64), or if there are
plenty of them.

-- 
short story of a lazy sysadmin:
 alias appserv=wotan
