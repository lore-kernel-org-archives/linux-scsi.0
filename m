From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Iscsitarget-devel] Re: [ANNOUNCE] iSCSI enterprise target
	software
Date: Tue, 01 Mar 2005 20:23:18 +0900
Message-ID: <20050301202318M.fujita.tomonori@lab.ntt.co.jp>
References: <20050301192257C.fujita.tomonori@lab.ntt.co.jp>
	<1109673220.6293.78.camel@laptopd505.fenrus.org>
	<1109673993.6293.80.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:51345 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S261875AbVCALXa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 06:23:30 -0500
In-Reply-To: <1109673993.6293.80.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: arjan@infradead.org
Cc: linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net

From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Iscsitarget-devel] Re: [ANNOUNCE] iSCSI enterprise target	software
Date: Tue, 01 Mar 2005 11:46:32 +0100

> note that on 32 bit servers the kernel side needs to do kmap() on the
> pages anyway, and that a kmap/kunmap series is very much equivalent to a
> mmap/munmap series in lots of ways, so I doubt that has many additional
> savings for doing it in kernel space.

The code uses the vfs interface, kmap_atomic() is used instead of
kmap(). kmap_atomic() is much faster kmap().
