From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] buslogic: use EH, remove some dup. docs
Date: Tue, 25 Nov 2003 08:25:05 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031125082505.B15604@infradead.org>
References: <20031124134628.7e827bcb.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:34821 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262127AbTKYIZH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 03:25:07 -0500
Content-Disposition: inline
In-Reply-To: <20031124134628.7e827bcb.rddunlap@osdl.org>; from rddunlap@osdl.org on Mon, Nov 24, 2003 at 01:46:28PM -0800
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org, jejb <james.bottomley@steeleye.com>

On Mon, Nov 24, 2003 at 01:46:28PM -0800, Randy.Dunlap wrote:
> 
> [resending this one]
> 
> Hi,
> 
> I think that this is ready to merge.
> Please apply to 2.6.0-testX-current.

You also need to kill the remants of the old error handling code,
which also hat a abort method which you probably should implement
aswell.  Without removing that it won't compile once we remove
scsi_obsolete.h (try compiling with that include commented out
in scsi.h).  Also why do you remove that big comment?  There doesn't
seem to be any relation to the new error handling code.

