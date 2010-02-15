From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SYNCHRONIZE CACHE command from sd on close
Date: Mon, 15 Feb 2010 17:48:47 -0500
Message-ID: <20100215224847.GA2490@infradead.org>
References: <4B79460A.7040207@interlog.com> <20100215132502.GA15360@infradead.org> <4B79515A.6020507@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54892 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab0BOWss (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2010 17:48:48 -0500
Content-Disposition: inline
In-Reply-To: <4B79515A.6020507@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Feb 15, 2010 at 02:51:22PM +0100, Douglas Gilbert wrote:
> What about O_NONBLOCK (which stops a hang on open)?
> The open code common to my utilities in Linux is
> below.

No, O_NONBLOCK should have nothing to do with it and your code
snipplet looks fine.  We'll need to figure out what's really going
on here.

