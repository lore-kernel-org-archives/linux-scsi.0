From: Andrew Morton <akpm@osdl.org>
Subject: Re: Fw: 2.5.75 - ppa unload PATCH and remaining problem
Date: Mon, 14 Jul 2003 10:10:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030714101041.65de0d72.akpm@osdl.org>
References: <20030713141556.13650fdb.akpm@osdl.org>
	<20030713234523.A7172@infradead.org>
	<20030713155612.37c7662b.akpm@osdl.org>
	<20030714153645.GA5969@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:33257 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S270720AbTGNRC7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2003 13:02:59 -0400
In-Reply-To: <20030714153645.GA5969@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, arvidjaar@mail.ru

Mike Anderson <andmike@us.ibm.com> wrote:
>
> I believe this problem is related to /proc/scsi cleanup issues
> previously discussed by Alan Stern.
> 
> I refreshed Alan's patch and added my host present bit cleanups to the
> last series of patches sent to the list.
> 
> I do not have a ppa device, but on 2.5.75 I saw a similar error
> signature of the proc not getting cleaned up when I use the aic7xxx_old
> which uses the legacy registration interfaces also. When I switched to
> my patched view the aic7xxx_old cleans up ok. I have other sysfs
> cleanups in this patched tree, but I do not believe they are effecting
> the legacy proc cleanups.

OK, thanks.

Where could we get the relevant diffs from for testers?
