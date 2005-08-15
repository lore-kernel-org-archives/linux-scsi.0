From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid 2.6: Fix aacraid probe breakage inscsi-block-2.6.git
Date: Mon, 15 Aug 2005 13:06:52 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01708AE0@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:59268 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S964831AbVHORJL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 13:09:11 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

The code does not 'damage' the scsi-misc tree version, so why not apply
it to the scsi-misc tree as well at least to make sure it does not
(extending the test coverage)? What is the scsi-block timetable for
downstream?

I have almost religiously applied all patches that touch the driver to
the Adaptec branch here. The net result is I have caught some gaffs
early on because we always have some test or Q/A program ready to give
it coverage.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Monday, August 15, 2005 1:01 PM
To: Mark Haverkamp
Cc: linux-scsi; Salyzyn, Mark
Subject: Re: [PATCH] aacraid 2.6: Fix aacraid probe breakage
inscsi-block-2.6.git

On Mon, 2005-08-15 at 09:53 -0700, Mark Haverkamp wrote:
> This patch fixes the bad assumption of the aacraid driver with use_sg.
> I used the 3w-xxxx driver fix as a guide for this.

Yes, that looks about right

> The patch applies to the scsi-block-2.6 git tree. Is that the right
> place for the patch?  Should it be applied to the scsi-misc or the
scsi-
> rc-fixes tree instead?

That's correct.  The problems are only caused by the scsi-block-2.6 tree
(I don't think too many people send INQUIRY or MODE_SENSE via SG_IO, so
no-one's reported the breakage in the main tree yet).

James


