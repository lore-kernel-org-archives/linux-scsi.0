From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Regarding Umount
Date: 04 May 2003 09:58:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052060310.10809.17.camel@mulgrave>
References: <20030504145234.83566.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:11525 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263623AbTEDOtr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 May 2003 10:49:47 -0400
In-Reply-To: <20030504145234.83566.qmail@mail.com>
List-Id: linux-scsi@vger.kernel.org
To: nmala@mail.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2003-05-04 at 09:52, nmala@mail.com wrote:
> What exactly does umount write?? Every time I umount my pseudo driver there are two calls to request with readwrite flag set to 1. Haven't been able to find a corresponding write in the trace of umount.

That depends on the fs.  One will almost certainly be the final
superblock update.

James


