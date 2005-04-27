From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [06/07] [PATCH] SCSI tape security: require CAP_ADMIN for
	SG_IO etc.
Date: Wed, 27 Apr 2005 17:38:49 +0100
Message-ID: <1114619928.18809.118.camel@localhost.localdomain>
References: <20050427171446.GA3195@kroah.com>
	 <20050427171649.GG3195@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:65477 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP id S261867AbVD0RoO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2005 13:44:14 -0400
In-Reply-To: <20050427171649.GG3195@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Cliff White <cliffw@osdl.org>, Theodore Ts'o <tytso@mit.edu>, "Randy.Dunlap" <rddunlap@osdl.org>, Chuck Wolber <chuckw@quantumlinux.com>, torvalds@osdl.org, akpm@osdl.org

On Mer, 2005-04-27 at 18:16, Greg KH wrote:
> -stable review patch.  If anyone has any objections, please let us know.

This patch is just wrong on so many different levels its hard to know
where to begin.

1. The auth for arbitary commands is CAP_SYS_RAWIO
2. "The SCSI command permissions were discussed widely on the linux
lists but this did not result in any useful refinement of the
permissions." - this is false. The process was refined, a table setup
was added and debugged. Someone even wrote an fs for managing it that is
not yet merged. Perhaps the patch author would care to re-read the
archives and submit a new patch if one is even needed
3. Pleas explain *what* the specific consistency problems are

And then please fix the same mess in 12rc.

Alan

