From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 02/11] st: add st_scsi_kern_execute helper function
Date: Mon, 1 Dec 2008 17:15:09 +0900
Message-ID: <20081201171510I.fujita.tomonori@lab.ntt.co.jp>
References: <1228032485-10328-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1228032485-10328-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<493282D0.6020006@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:56493 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbYLAIPi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2008 03:15:38 -0500
In-Reply-To: <493282D0.6020006@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, Kai.Makisara@kolumbus.fi, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Sun, 30 Nov 2008 14:10:56 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> would you say that the only reason we cannot use scsi_execute inside st_scsi_kern_execute
> is because we don't have residual count returned from scsi_execute ?

Yeah, it's one of reasons. I don't want to create dependence. But once
the patchset is merged, I might try to change scsi_execute() for st.

But maybe not since I might change st_scsi_kern_execute to handle
st_read/st_write data transfer (between user and kernel space).
