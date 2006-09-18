From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch] SCSI statistics
Date: Mon, 18 Sep 2006 15:34:24 -0600
Message-ID: <20060918213424.GS2585@parisc-linux.org>
References: <1158578439.3060.50.camel@dyn-9-152-230-71.boeblingen.de.ibm.com> <1158614913.3182.78.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:61580 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1751093AbWIRVe0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 17:34:26 -0400
Content-Disposition: inline
In-Reply-To: <1158614913.3182.78.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Martin Peschke <mp3@de.ibm.com>, linux-scsi@vger.kernel.org

On Mon, Sep 18, 2006 at 11:28:32PM +0200, Arjan van de Ven wrote:
> wouldn't this be nicer as a block level functionality?

We already have block layer statistics.  What we don't have are stats
that measure the other ways to send commands to scsi devices like SG and
retries that the scsi system does without notifying the block layer.  I
think both are useful (although at first glance they seem redundant).
