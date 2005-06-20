From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] remove scsi_cmnd.eh_state
Date: Mon, 20 Jun 2005 14:35:26 +0200
Message-ID: <20050620123526.GA6222@lst.de>
References: <60807403EABEB443939A5A7AA8A7458B01520CD8@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:4802 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261238AbVFTMfc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 08:35:32 -0400
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B01520CD8@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Jun 20, 2005 at 08:28:50AM -0400, Salyzyn, Mark wrote:
> If the code is not in place, then array devices will go offline.
> 
> The array needs to have a 5 minute timeout, all other devices can
> timeout as per the SCSI subsystem.

The proper API to do that is to set scsi_device.timeout in
->slave_configure.

