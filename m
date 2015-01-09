From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] scsi: Move user-shareable stuff in scsi/scsi.h to
	uapi/scsi/scsi.h
Date: Fri, 9 Jan 2015 18:11:48 +0100
Message-ID: <20150109171148.GA17380@lst.de>
References: <1420746479-25949-1-git-send-email-agrover@redhat.com> <1420746479-25949-3-git-send-email-agrover@redhat.com> <20150109101422.GA23804@lst.de> <1420817266.2064.1.camel@HansenPartnership.com> <20150109154613.GA29124@lst.de> <1420818638.2064.5.camel@HansenPartnership.com> <20150109160140.GA29372@lst.de> <1420821180.2064.10.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36971 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757279AbbAIRLv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jan 2015 12:11:51 -0500
Content-Disposition: inline
In-Reply-To: <1420821180.2064.10.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org

On Fri, Jan 09, 2015 at 08:33:00AM -0800, James Bottomley wrote:
> Yes, but they have to be delivered to users somehow.  If you look at
> debian, they deliver the headers through the linux-dev-libc package
> which installs into the /usr/include directory.

linux-libc-dev despite the name is provided from the kernel source package:

https://packages.debian.org/sid/linux-libc-dev

> Since glibc currently
> owns the entirety of /usr/include/scsi, we have to help the distros
> figure out how we deliver the headers, otherwise all uapi exports of
> SCSI stuff just gets ignored ...

That's why I've been arguing for adding a new linux/scsi_ioctl.h header
to bypass that whole conflict since my first mail in this thread.
