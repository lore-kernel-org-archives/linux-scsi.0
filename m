From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6 patch] SCSI: possible cleanups
Date: Mon, 28 Feb 2005 23:34:47 +0000
Message-ID: <20050228233447.GA20340@infradead.org>
References: <20050228213159.GO4021@stusta.de> <20050228222509.GB19376@infradead.org> <20050228230155.GV4021@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:44672 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261817AbVB1Xev (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2005 18:34:51 -0500
Content-Disposition: inline
In-Reply-To: <20050228230155.GV4021@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Christoph Hellwig <hch@infradead.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Mark_Salyzyn@adaptec.com

On Tue, Mar 01, 2005 at 12:01:55AM +0100, Adrian Bunk wrote:
> On Mon, Feb 28, 2005 at 10:25:09PM +0000, Christoph Hellwig wrote:
> >...
> > >   - constants.c: scsi_print_hostbyte
> > >   - constants.c: scsi_print_driverbyte
> > 
> > these we'll probably keep for now.
> >...
> 
> keep = #if 0 ?

In this case yes, for the others case I want to keep them beeing built.
