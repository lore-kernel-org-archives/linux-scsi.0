From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support -
 revised II
Date: Thu, 30 Oct 2008 17:29:23 +0900
Message-ID: <20081030172537K.fujita.tomonori@lab.ntt.co.jp>
References: <E35CF40D-87CC-4AA2-91EC-31064F70198E@qlogic.com>
	<20081030131825M.fujita.tomonori@lab.ntt.co.jp>
	<4909678C.1010908@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46300 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbYJ3I3v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2008 04:29:51 -0400
In-Reply-To: <4909678C.1010908@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, seokmann.ju@qlogic.com, James.Smart@Emulex.Com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, robert.w.love@intel.com

On Thu, 30 Oct 2008 09:51:40 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> Do you know what is the difference between "req->error =" and the error
> passed to blk_end_xxx_request(req, error, ...) ?

I guess that blk_end_xxx_request(req, error, ...) is common Linux
error code, -EIO, etc. req->error carries protocol specific errors;
SAM_STAT_*, DID_*, etc in the case of SCSI. But I'm not confident.
