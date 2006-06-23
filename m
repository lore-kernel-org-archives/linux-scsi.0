From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] kmalloc arguments in wrong order (53c700)
Date: Thu, 22 Jun 2006 21:55:57 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0606222153280.6483@g5.osdl.org>
References: <20060622204813.GY27946@ftp.linux.org.uk> <449B39E7.6040701@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:17349 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932301AbWFWE4L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 00:56:11 -0400
In-Reply-To: <449B39E7.6040701@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-scsi@vger.kernel.org



On Thu, 22 Jun 2006, Douglas Gilbert wrote:

> Al Viro wrote:
> > Could people please run make C=2 at some point?
> 
> Is "sparse" packaged somewhere?

I don't think it is, but it is easy enough to build.

	git clone git://git.kernel.org/pub/scm/devel/sparse/sparse.git
	cd sparse
	make
	make install

should do it.

Modern gcc's give a ton of

	warning: value computed is not used

warnings, but quite frankly, that's a gcc bug, not a a sparse problem. 

			Linus
