From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ServeRAID Seeing DADSI Devices
Date: Wed, 1 Feb 2006 10:25:26 +0000
Message-ID: <20060201102525.GA7404@infradead.org>
References: <43DFA9D3.9030408@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37040 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030377AbWBAKZ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Feb 2006 05:25:27 -0500
Content-Disposition: inline
In-Reply-To: <43DFA9D3.9030408@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Hammer <jack_hammer@adaptec.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

On Tue, Jan 31, 2006 at 01:17:55PM -0500, Jack Hammer wrote:
> A critical thing the ServeRAID driver MUST do is hide the physical DASDI
> devices from the OS. It does this by intercepting the INQUIRY commands. 

No, it must not.  What itu should do instead is to set the no_uld_attach flag.

