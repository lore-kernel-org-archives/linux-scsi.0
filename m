From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Fw: 2.5.75 - ppa unload PATCH and remaining problem
Date: Mon, 14 Jul 2003 08:36:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030714153645.GA5969@beaverton.ibm.com>
References: <20030713141556.13650fdb.akpm@osdl.org> <20030713234523.A7172@infradead.org> <20030713155612.37c7662b.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:51072 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S270673AbTGNPVM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2003 11:21:12 -0400
Content-Disposition: inline
In-Reply-To: <20030713155612.37c7662b.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, arvidjaar@mail.ru

I believe this problem is related to /proc/scsi cleanup issues
previously discussed by Alan Stern.

I refreshed Alan's patch and added my host present bit cleanups to the
last series of patches sent to the list.

I do not have a ppa device, but on 2.5.75 I saw a similar error
signature of the proc not getting cleaned up when I use the aic7xxx_old
which uses the legacy registration interfaces also. When I switched to
my patched view the aic7xxx_old cleans up ok. I have other sysfs
cleanups in this patched tree, but I do not believe they are effecting
the legacy proc cleanups.

-andmike
--
Michael Anderson
andmike@us.ibm.com

