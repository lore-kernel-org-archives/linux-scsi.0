From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] scsi: Move user-shareable stuff in scsi/scsi.h to
	uapi/scsi/scsi.h
Date: Fri, 9 Jan 2015 17:01:40 +0100
Message-ID: <20150109160140.GA29372@lst.de>
References: <1420746479-25949-1-git-send-email-agrover@redhat.com> <1420746479-25949-3-git-send-email-agrover@redhat.com> <20150109101422.GA23804@lst.de> <1420817266.2064.1.camel@HansenPartnership.com> <20150109154613.GA29124@lst.de> <1420818638.2064.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36816 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757721AbbAIQBn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jan 2015 11:01:43 -0500
Content-Disposition: inline
In-Reply-To: <1420818638.2064.5.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org

On Fri, Jan 09, 2015 at 07:50:38AM -0800, James Bottomley wrote:
> Right, that's why I'm dubious about this effort.  uapi files either have
> to become the glibc headers or be exported in a way that allows
> inclusion into glibc headers for there to be any point.

uapi headers are not just for glibc, they are for any userspace
application.  Most of our uapi files aren't used by glibc at all.
