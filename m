From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6.11-rc4-mm1 patch] drivers/scsi/arcmsr/arcmsr.c cleanups
Date: Sun, 27 Feb 2005 22:23:05 +0000
Message-ID: <20050227222305.GA1847@infradead.org>
References: <20050223014233.6710fd73.akpm@osdl.org> <20050227154810.GA6148@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:51673 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261489AbVB0WXR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Feb 2005 17:23:17 -0500
Content-Disposition: inline
In-Reply-To: <20050227154810.GA6148@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, Erich Chen <erich@areca.com.tw>, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Sun, Feb 27, 2005 at 04:48:10PM +0100, Adrian Bunk wrote:
> - aren't the "if defined(__x86_64__)" wrong for other 64bit
>   architectures?

Yes.  Having arch or 64bit ifdefs is pretty wrong pretty much always.
In one case it's only used to make a typedef a 32bit or 64bit integeger,
that should be using unsigned long directly always, but the other uses
looks like real problems.

