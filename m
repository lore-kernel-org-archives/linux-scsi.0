From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6 aacraid: Add sysfs files for aacraid adapter information (re-diff)
Date: Mon, 23 May 2005 14:46:33 +0100
Message-ID: <20050523134633.GA14207@infradead.org>
References: <60807403EABEB443939A5A7AA8A7458B0132B6EC@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37868 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261613AbVEWNqh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2005 09:46:37 -0400
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B0132B6EC@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, May 23, 2005 at 07:56:58AM -0400, Salyzyn, Mark wrote:
> >Again please remove the prefix.  Also what does kernel version mean in
> >this context?
> 
> This is the kernel running in the Firmware of the Adapter.

shouldn't we call this fw_version or firmware_version then?

> I would be concerned about "kernel_version" confusion in the namespace
> of the /sys/ filesystem. Dropping the prefix is not an issue, but do we
> have documented naming standards for driver & firmware specific details?

Unfortunately not.  I tried to get these attributes standardized at the
driver core level, but gregkh vetoed that.

The first scsi driver with lots of version attributes is the Emulex lpfc
driver so it might help to follow that one.
