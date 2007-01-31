From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid: Add kernel command line parameter parsing
Date: Wed, 31 Jan 2007 09:55:08 +0000
Message-ID: <20070131095508.GA3200@infradead.org>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01483B4A@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56281 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788AbXAaJzL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jan 2007 04:55:11 -0500
Content-Disposition: inline
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01483B4A@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Mark Haverkamp <markh@linux-foundation.org>

On Tue, Jan 30, 2007 at 04:42:28PM -0500, Salyzyn, Mark wrote:
> One shortcoming of the driver relationship with the kernel is that there
> is no standard means of having the insmod parameters associated with a
> driver to also be parsed and set by the kernel parameter line.

Actually there is.  In Linux 2.6 every module paramter can also specified
as <modulename>.<parameter> on the kernel command line.

Thus you patch is superflous and should not be applied.

