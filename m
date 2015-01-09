From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] scsi: Move user-shareable stuff in scsi/scsi.h to
	uapi/scsi/scsi.h
Date: Fri, 9 Jan 2015 11:14:22 +0100
Message-ID: <20150109101422.GA23804@lst.de>
References: <1420746479-25949-1-git-send-email-agrover@redhat.com> <1420746479-25949-3-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35950 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229AbbAIKO0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jan 2015 05:14:26 -0500
Content-Disposition: inline
In-Reply-To: <1420746479-25949-3-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, hch@lst.de

On Thu, Jan 08, 2015 at 11:47:58AM -0800, Andy Grover wrote:
> A great many SCSI codes and ioctl values can be made available to userspace
> in a uapi header, while the kernel-only definitions stay in scsi/scsi.h.
> 
> scsi/scsi.h also includes uapi/scsi/scsi.h so kernel code need not update
> includes.

SCSI opcodes are not a user API/ABI, so they should not be exported.

I'm fine with having them in their own header that can be copied
into other projects, but guaranteeing any sort of stability for these
defines is a mistake.
