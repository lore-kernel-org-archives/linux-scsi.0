From: Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] 2.6.25-rc6 initio senselen warning
Date: Fri, 28 Mar 2008 06:08:59 -0400
Message-ID: <20080328100859.GA12698@devserv.devel.redhat.com>
References: <20080328055143.GA27045@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbYC1KJv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 06:09:51 -0400
Content-Disposition: inline
In-Reply-To: <20080328055143.GA27045@colo.lackof.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>

On Thu, Mar 27, 2008 at 11:51:43PM -0600, Grant Grundler wrote:
> 
> Building initio on parisc with gcc-4.3 yielded this warning:
> drivers/scsi/initio.c:2585: warning: large integer implicitly truncated to unsigned type
> 
> and the code was:
>         cblk->senselen = cpu_to_le32(SENSE_SIZE);
> 
> Given senselen is a u8, code is wrong.
> 
> Signed-off-by: Grant Grundler <grundler@parisc-linux.org>

Acked-by: Alan Cox <alan@redhat.com>
