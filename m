From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] LLDD dynamic scan aids
Date: Thu, 18 Nov 2004 14:36:44 +0000
Message-ID: <20041118143644.GA23365@infradead.org>
References: <60807403EABEB443939A5A7AA8A7458B694682@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:56583 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262102AbUKROgr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2004 09:36:47 -0500
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B694682@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, Mark Haverkamp <markh@osdl.org>

On Thu, Nov 18, 2004 at 09:32:09AM -0500, Salyzyn, Mark wrote:
> But scsi_rescan_device and scsi_scan_host_selected both target specific
> ids though? As long as we stay away from the wildcards for
> scsi_scan_host_selected, or am I mistaken?

scsi_rescan_device should be exported.  For the target scan something
like the second hunk of James' patch looks good to me.

