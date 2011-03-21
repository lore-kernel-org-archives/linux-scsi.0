From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Tue, 22 Mar 2011 08:30:16 +0900
Message-ID: <20110322083024R.fujita.tomonori@lab.ntt.co.jp>
References: <4D83C78D.5040908@linux.vnet.ibm.com>
	<20110321100909E.fujita.tomonori@lab.ntt.co.jp>
	<4D87CF99.7040008@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:34951 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab1CUXa1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 19:30:27 -0400
In-Reply-To: <4D87CF99.7040008@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, nab@linux-iscsi.org, linux-scsi@vger.kernel.org

On Mon, 21 Mar 2011 17:22:17 -0500
Brian King <brking@linux.vnet.ibm.com> wrote:

> Thanks for all the work you've done with this driver. It is much
> appreciated.

No problem. Thanks for the testing.


> What sort of performance are you seeing with this? With filebacked devices, I
> was seeing around 1 MB/sec doing a basic disktest run. I haven't compared this
> to ibmvstgt, but I'm pretty sure we did a fair bit better there. Perhaps I've got
> some setup issue?

I've not done performance tests here but surely we should do
better. I'll do but we might need to fix the target core too for the
better performance.
