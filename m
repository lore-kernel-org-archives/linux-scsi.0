From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] remove scsi_cmnd.eh_state
Date: Mon, 20 Jun 2005 14:28:05 +0200
Message-ID: <20050620122805.GA6121@lst.de>
References: <60807403EABEB443939A5A7AA8A7458B01520CD6@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:61889 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261228AbVFTM2L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 08:28:11 -0400
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B01520CD6@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Jun 20, 2005 at 08:26:24AM -0400, Salyzyn, Mark wrote:
> A bugfix was submitted a couple of weeks ago for the code affected by
> Christoph's patch. I suggest the following modification to merge the two
> patches:

No, it's not a bugfix.  Any access of a driver to eh_timeout is a bug.

