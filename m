From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] scsi: Remove scsi_ioctl.h
Date: Fri, 9 Jan 2015 10:05:02 +0100
Message-ID: <20150109090502.GA21959@lst.de>
References: <1420746479-25949-1-git-send-email-agrover@redhat.com> <1420746479-25949-4-git-send-email-agrover@redhat.com> <1420749302.5830.31.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35811 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbbAIJFG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jan 2015 04:05:06 -0500
Content-Disposition: inline
In-Reply-To: <1420749302.5830.31.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org, hch@lst.de

On Thu, Jan 08, 2015 at 12:35:02PM -0800, James Bottomley wrote:
> What's the transition plan for userspace?  If you look at glibc
> currently, it supplies both scsi.h and scsi_ioctl.h.  If we're
> persuading the glibc folks to go with our versions from uapi, I think
> removing a file which is an effective compile breaker for userspace i=
s a
> really bad idea.  Duplicating scsi_ioctl.h definitions in scsi.h woul=
d
> also cause them problems.

I thought about this a wh=D1=96le ago, and I think reusing scsi/*.h is =
a bad
idea exactly because glibc provides old versions of these.

I'd suggest adding a linux/uapi/scsi_ioctl.h instead.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
