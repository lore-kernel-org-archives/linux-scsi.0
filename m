From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 12/25] scsi: move SG_IO ioctl32 code to sg.c
Date: Sat, 05 Nov 2005 10:44:59 -0600
Message-ID: <1131209099.3614.7.camel@mulgrave>
References: <20051105162650.620266000@b551138y.boeblingen.de.ibm.com>
	 <20051105162715.367344000@b551138y.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:29134 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932151AbVKEQpD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Nov 2005 11:45:03 -0500
In-Reply-To: <20051105162715.367344000@b551138y.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

On Sat, 2005-11-05 at 17:27 +0100, Arnd Bergmann wrote:
> plain text document attachment (sg-ioctl.diff)
> The sg driver already has a compat_ioctl function, so the
> conversion handler for SG_IO can easily be moved in there
> as well. It still uses compat_alloc_user_space, so it can
> probably be simplified by using merging the conversion
> handler with the native method.

This is the wrong place, isn't it?  SG_IO is also in
drivers/block/scsi_ioctl.c which isn't modular, so shouldn't this be in
there?

James


