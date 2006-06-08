From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] aacraid: small misc. cleanups
Date: Thu, 8 Jun 2006 21:12:23 +0100
Message-ID: <20060608201223.GB21996@infradead.org>
References: <1149785480.22364.18.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:7886 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964975AbWFHUMY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jun 2006 16:12:24 -0400
Content-Disposition: inline
In-Reply-To: <1149785480.22364.18.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Thu, Jun 08, 2006 at 09:51:20AM -0700, Mark Haverkamp wrote:
> Received from Mark Salyzyn
> 
> Spelling correction, orphaned comment removal & warning suppression.

the = 0 initializations shouldn't go in.  They hack around bugs in recent
gcc versions that should be fixed in gcc instead.

