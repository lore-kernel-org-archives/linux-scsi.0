From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 01 Mar 2005 09:40:38 +0100
Message-ID: <1109666441.6293.62.camel@laptopd505.fenrus.org>
References: <20050301161951K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:2439 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261600AbVCAIkp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 03:40:45 -0500
In-Reply-To: <20050301161951K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net

On Tue, 2005-03-01 at 16:19 +0900, FUJITA Tomonori wrote:

> The user-space daemon handles authentication and the kernel threads
> take care of network and disk I/O requests from initiators by using
> the VFS interface. The kernel-space code is not intrusive. It doesn't
> touch other parts of the kernel. The code is already stable and
> usable. More than 130 people currently subscribe to the project's
> mailing list. The developers aim for inclusion into the mainline
> kernel.

> Could you please review the code? Any comments are greatly
> appreciated.
> -

can you explain why the target has to be inside the kernel and can't be
a pure userspace daemon ?


