From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI Initio 9100UW (INIC-950p chipset) support nunder kernel 2.6.x
Date: Wed, 22 Sep 2004 17:06:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040922170651.A3340@infradead.org>
References: <4151A24A.7000302@fabricadeideias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:17168 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266189AbUIVQGx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 12:06:53 -0400
Content-Disposition: inline
In-Reply-To: <4151A24A.7000302@fabricadeideias.com>; from rodrigo.lists@fabricadeideias.com on Wed, Sep 22, 2004 at 01:03:00PM -0300
List-Id: linux-scsi@vger.kernel.org
To: Rodrigo Severo <rodrigo.lists@fabricadeideias.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Sep 22, 2004 at 01:03:00PM -0300, Rodrigo Severo wrote:
> with kernel 2.4.24 (yes, I know it's old).
> 
> I want to update my kernel do 2.6.8. The question: is there support for 
> this board/chipset under kernel 2.6.x?
> 
> I looked around a lot and couldn't find much. www.initio.com says their 
> code is in the kernel since 2.0.32. Has it been left out for 2.6.x?
> 
> Is anyone working on this port? Anyone intending to work on it?

The driver still exists and actually compiles.  It's marked BROKEN, although
I don't know why.  If you want to help testing we can update it to current
standards.

