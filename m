From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6.9 aacraid: aac_count fix
Date: Thu, 16 Sep 2004 19:22:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040916192245.A4271@infradead.org>
References: <1095347689.2440.24.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:26637 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268203AbUIPSW7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2004 14:22:59 -0400
Content-Disposition: inline
In-Reply-To: <1095347689.2440.24.camel@markh1.pdx.osdl.net>; from markh@osdl.org on Thu, Sep 16, 2004 at 08:14:49AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>


the earlier scsi_add_host is wrong unfortunately, you must only call
scsi_add_host once the controller is ready to accept I/O.  Where do you
need to derefence the device in there?

Is this the host_lock problem seen in a few other drivers?
