From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aacraid 2.6: Fix aacraid probe breakage in
	scsi-block-2.6.git
Date: Mon, 15 Aug 2005 12:01:17 -0500
Message-ID: <1124125277.5089.29.camel@mulgrave>
References: <1123694406.30596.10.camel@markh1.pdx.osdl.net>
	 <1123694836.5134.14.camel@mulgrave>
	 <1124124823.12657.12.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:12493 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964846AbVHORBZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 13:01:25 -0400
In-Reply-To: <1124124823.12657.12.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Mon, 2005-08-15 at 09:53 -0700, Mark Haverkamp wrote:
> This patch fixes the bad assumption of the aacraid driver with use_sg.
> I used the 3w-xxxx driver fix as a guide for this.

Yes, that looks about right

> The patch applies to the scsi-block-2.6 git tree. Is that the right
> place for the patch?  Should it be applied to the scsi-misc or the scsi-
> rc-fixes tree instead?

That's correct.  The problems are only caused by the scsi-block-2.6 tree
(I don't think too many people send INQUIRY or MODE_SENSE via SG_IO, so
no-one's reported the breakage in the main tree yet).

James


