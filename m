From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3] scsi: Move user-shareable stuff in scsi/scsi.h to
 uapi/scsi/scsi.h
Date: Fri, 09 Jan 2015 08:33:00 -0800
Message-ID: <1420821180.2064.10.camel@HansenPartnership.com>
References: <1420746479-25949-1-git-send-email-agrover@redhat.com>
	 <1420746479-25949-3-git-send-email-agrover@redhat.com>
	 <20150109101422.GA23804@lst.de>
	 <1420817266.2064.1.camel@HansenPartnership.com>
	 <20150109154613.GA29124@lst.de>
	 <1420818638.2064.5.camel@HansenPartnership.com>
	 <20150109160140.GA29372@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46103 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561AbbAIQdC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2015 11:33:02 -0500
In-Reply-To: <20150109160140.GA29372@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org

On Fri, 2015-01-09 at 17:01 +0100, Christoph Hellwig wrote:
> On Fri, Jan 09, 2015 at 07:50:38AM -0800, James Bottomley wrote:
> > Right, that's why I'm dubious about this effort.  uapi files either have
> > to become the glibc headers or be exported in a way that allows
> > inclusion into glibc headers for there to be any point.
> 
> uapi headers are not just for glibc, they are for any userspace
> application.  Most of our uapi files aren't used by glibc at all.

Yes, but they have to be delivered to users somehow.  If you look at
debian, they deliver the headers through the linux-dev-libc package
which installs into the /usr/include directory.  Since glibc currently
owns the entirety of /usr/include/scsi, we have to help the distros
figure out how we deliver the headers, otherwise all uapi exports of
SCSI stuff just gets ignored ... as it does today because there are no
kernel SCSI uapi headers in linux-libc-dev.

James


