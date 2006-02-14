From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] aacraid: use kthread_ API
Date: Tue, 14 Feb 2006 18:54:59 +0100
Message-ID: <20060214175459.GF19080@lst.de>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F0222C7CC@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:13261 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1422724AbWBNRzD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2006 12:55:03 -0500
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F0222C7CC@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Feb 14, 2006 at 12:53:06PM -0500, Salyzyn, Mark wrote:
> Looks good by me, save that it would be nicer to use either
> AAC_DRIVERNAME or aac->name instead of yet another hard coded string.

I just copied that from the previous code.  But yes, avoiding the
hardcoded string would be nicer.  I'll send a followup-patch ASAP.

