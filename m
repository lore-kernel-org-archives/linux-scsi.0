From: Andrew Morton <akpm@osdl.org>
Subject: Re: 3Ware delayed device mounting errors with newer 9500 series
 adapters
Date: Sat, 21 Oct 2006 23:39:04 -0700
Message-ID: <20061021233904.c2f40a5f.akpm@osdl.org>
References: <453A52CE.80605@wolfmountaingroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:38596 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1423049AbWJVGjI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Oct 2006 02:39:08 -0400
In-Reply-To: <453A52CE.80605@wolfmountaingroup.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Jeffrey V. Merkey" <jmerkey@wolfmountaingroup.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linuxraid@amcc.com, linux-scsi@vger.kernel.org

On Sat, 21 Oct 2006 11:03:10 -0600
"Jeffrey V. Merkey" <jmerkey@wolfmountaingroup.com> wrote:

> 
> Adam,
> 
> We have been getting 3Ware 9500 series adapters in the past 60 days 
> which exhibit a delayed behavior during mounting of FS from
> /etc/fstab.   The adapters older than this do not exhibit this behavior. 
> 
> During bootup, if the driver is compiled as a module rather than in 
> kernel, mount points such as /var in fstab fail to detect the devices
> until the system fully boots, at which point the /dev/sdb etc. devices 
> showup.  It happens on both ATA cabled drives and drives
> cabled with multi-lane controller backplanes.
> 
> The problem is easy to reproduce.  Install ES4, point the /var directory 
> during install to one of the array devices in disk druid, and after
> the install completes, /var/ will not mount during bootup and all sorts 
> of errors stream off the screen.  I can reproduce the problem
> with several systems in our labs and upon investigating the adapter 
> revisions, I find that adapters ordered in the past 60 days exhibit
> the problem.   Compiling the driver in kernel gets around the problem, 
> indicating its timing related.
> 

cc's added.
