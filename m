From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] MPT Fusion driver update
Date: Tue, 11 Nov 2003 09:22:50 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031111092249.A5879@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57035A9E21@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:12561 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263448AbTKKJWx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2003 04:22:53 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57035A9E21@exa-atlanta.se.lsil.com>; from emoore@lsil.com on Mon, Nov 10, 2003 at 10:17:36AM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <emoore@lsil.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Mon, Nov 10, 2003 at 10:17:36AM -0500, Moore, Eric Dean wrote:
> Christoph,
> 
> Can you let me know what the *real problems* are with the
> driver.

Please read the replies to previous driver updates, like the error handling
problems worked around in 2.4 by using the old EH, the total lack of module
refcounting in 2.4 and the data corruption issues Andi Kleen sees on
x86_64.  Just search the list updates for fusion..

> In addition, its going to be very difficult to 
> inline source into email clients. The problem that I see
> are the tabs and over 80 characters per line. I've tried 
> a handful of email clients, non work

mutt seems to work..

