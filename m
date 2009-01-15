From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: support of sg_iovec in bsg's struct sg_io_v4
Date: Thu, 15 Jan 2009 14:58:17 +0900
Message-ID: <20090115145804D.fujita.tomonori@lab.ntt.co.jp>
References: <496E2863.40103@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46693 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047AbZAOF6i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2009 00:58:38 -0500
In-Reply-To: <496E2863.40103@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, osd-dev@open-osd.org

On Wed, 14 Jan 2009 20:01:07 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> Is below just missing or is there something I do not understand?
> 
> It looks like the conversion from struct sg_io_hdr to struct sg_io_v4 the use
> of sg_iovec was dropped. Even though all the members and code comments
> say it is the same.

It's intentional. It has been discussed several times on linux-scsi.


> This adds the support in bsg and struct sg_io_v4 exactly in the same way
> it was done in sg with struct sg_io_hdr.

sg_io_v4 will not support sg_iovec.


> BTW why is the ioctl SG_IO defined exactly the same for sg.c and bsg.c
> even though they have none compatible API/ABI? Is that because we have the
> protection of the first __s32 member that is 'Q' for bsg and 'S' or 0 for
> sg? Is that usually done with ioctl's?

I don't know if it's common or not. But we did the same thing with sg
v2 and sg v3's read/write interface.
