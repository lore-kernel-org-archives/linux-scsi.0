From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Qemu-devel] RFC: Implement emulation of pSeries logical
 partitions
Date: Mon, 14 Feb 2011 13:16:44 +0900
Message-ID: <20110214131639P.fujita.tomonori@lab.ntt.co.jp>
References: <1297522467-5975-1-git-send-email-david@gibson.dropbear.id.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:43039 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068Ab1BNERq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Feb 2011 23:17:46 -0500
In-Reply-To: <1297522467-5975-1-git-send-email-david@gibson.dropbear.id.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david@gibson.dropbear.id.au
Cc: qemu-devel@nongnu.org, paulus@samba.org, agraf@suse.de, anton@samba.org, linux-scsi@vger.kernel.org

On Sun, 13 Feb 2011 01:54:12 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> This patch series adds a "pseries" machine to qemu, allowing it to
> emulate IBM pSeries logical partitions.  Along the way we add a bunch
> of support for more modern ppc CPUs than are currently supported.  It
> also makes some significant cleanups to the translation code for hash
> page table based ppc MMUs.
> 
> This is a first version of this series for review.  There are a number
> of additional patches adding features such as virtual IO devices to
> the emulated pSeries platform, which will be added to the series once
> they're a bit more polished.

The communication between LPARs that can be used for something like
VIO server is (or will be) supported?
