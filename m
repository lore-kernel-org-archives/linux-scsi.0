From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH resend] include/linux: Add bsg.h to the Kernel exported
 headers
Date: Mon, 19 Jan 2009 05:38:27 +0900
Message-ID: <20090119053818L.fujita.tomonori@lab.ntt.co.jp>
References: <20090115164824.e637b8c6.akpm@linux-foundation.org>
	<20090116065003.GU30821@kernel.dk>
	<4972E6FD.8070405@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:45100 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbZARUp7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jan 2009 15:45:59 -0500
In-Reply-To: <4972E6FD.8070405@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com, jens.axboe@oracle.com
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, dougg@torque.net, stable@kernel.org

On Sun, 18 Jan 2009 10:23:25 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
> bsg.h in current form is perfectly suitable for user-mode
> consumption. It is needed together with scsi/sg.h for applications
> that want to interface with the bsg driver.
> 
> Currently the few projects that use it would copy it over into
> the projects. But that is not acceptable for projects that need
> to provide source and devel packages for distros.
> 
> This should also be submitted to stable 2.6.28 and 2.6.27 since bsg had
> a stable API since these Kernels and distro users will need the header
> for these kernels a swell
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> Ack-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
