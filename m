From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support -
 revised II
Date: Fri, 31 Oct 2008 08:12:17 +0900
Message-ID: <20081031081211E.fujita.tomonori@lab.ntt.co.jp>
References: <E35CF40D-87CC-4AA2-91EC-31064F70198E@qlogic.com>
	<20081030131825M.fujita.tomonori@lab.ntt.co.jp>
	<BDE35A87-59AD-4116-9DB8-F1DFAD40177A@qlogic.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:42516 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbYJ3XMw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2008 19:12:52 -0400
In-Reply-To: <BDE35A87-59AD-4116-9DB8-F1DFAD40177A@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Smart@Emulex.Com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, bharrosh@panasas.com, michaelc@cs.wisc.edu, robert.w.love@intel.com

On Thu, 30 Oct 2008 06:37:41 -0700
Seokmann Ju <seokmann.ju@qlogic.com> wrote:

> > btw, tha name 'payload_dma' sounds a bit odd to me. Software FCoE
> > drivers doesn't do dma for data transfer, right?
> OK. The type case has removed.
> Any suggestion on the name change?
> Please let me know if you have it. I will take it.

sg_req and sg_rsp or sg_in and sg_out?
