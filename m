From: Linux Christoph Hellwig <hch@infradead.org>
Subject: Re: About ARECA RAID driver for Linux i386/x86-64
Date: Fri, 18 Feb 2005 16:10:21 +0000
Message-ID: <20050218161021.GA21802@infradead.org>
References: <000801c514c7$04ec0030$9300a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:8872 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261390AbVBRQK3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 11:10:29 -0500
Content-Disposition: inline
In-Reply-To: <000801c514c7$04ec0030$9300a8c0@erich2003>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: erich <erich@areca.com.tw>
Cc: Linux Andrew Morton <akpm@osdl.org>, Linux James Bottomley <James.Bottomley@SteelEye.com>, Linux Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org

On Thu, Feb 17, 2005 at 04:02:25PM +0800, erich wrote:
> Hi,Andrew Morton
> 
> I had clean up "arcmsr" for linux kernel 2.6.10.
> May be it looks more cleanly  than old version.

Sorry, but I don't see that much of a difference ;-)

To get the driver into a shape where we can actually
start a review, do run the shell script scripts/Lindent
from the kernel tree over the driver, and please kill
all your SHOUTING typedefs for kernel types.  After
that compare it with the file Documentation/CodingStyle,
also in the kernel tree and try to fix up whatever seems
to not match up.
