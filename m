From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] pm8001: support HDA (flashless) mode
Date: Sat, 28 Apr 2012 09:06:09 +0800
Message-ID: <5ADF3694BDC14FC2BF986C45DFBDD819@usish.com.cn>
References: <420864BE-8542-4BD8-B3DB-FDA403D193F9@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:42340 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab2D1BGI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Apr 2012 21:06:08 -0400
In-Reply-To: <420864BE-8542-4BD8-B3DB-FDA403D193F9@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mark Salyzyn' <mark_salyzyn@xyratex.com>, linux-scsi@vger.kernel.org
Cc: 'James Bottomley' <JBottomley@parallels.com>, 'lindar_liu' <lindar_liu@usish.com>, =?gb2312?B?J9PasK67qic=?= <crystal_yu@usish.com>, 'john_gong' <john_gong@usish.com>

Thanks Mark,

So how we get the bin images? PMCS only offer the converted c Header file
for this, we need users who want to use this function convert the header
file to bin file.

Patch need a little more time to look into, will comment back soon.

Jack


> 
> The pm8001 can be delivered as a standalone product with flash-programmed
> firmware images, or without the flash present requiring the driver to
upload
> the images into the chip's RAM and then run. This is called HDA mode.
> 
> We add support for this firmware upload in the enclosed patch. We try some
> basic initialization checks of the Firmware, and if it appears dead, we
make
> the assumption the adapter must in-fact be halted in this HDA mode. The
> Firmware images themselves have not been cleared for open-release by PMC,
but
> they are available in OpenSolaris <hint hint>. PMC's rationalization for
not
> wanting an open-release of the Firmware Images is that they do not want to
> take support calls except from paying OEMs (such as Xyratex) that are
embedding
> PMC product into the motherboards and thus may have a tested combination
of
> Firmware and Hardware. Please respect this sentiment. Images are expected
in:
> 
> /lib/firmware/aap1img.bin
> /lib/firmware/ilaimg.bin
> /lib/firmware/iopimg.bin
> /lib/firmware/istrimg.bin
> 
> using the exact same naming convention as PMC and in OpenSolaris (and its
> followon children) for these image files.
> 
> Signed-off-by: Mark Salyzyn <mark_salyzyn@xyratex.com>
> 
>  drivers/scsi/pm8001/pm8001_hwi.c  |  584
> +++++++++++++++++++++++++++++++++++---
>  drivers/scsi/pm8001/pm8001_hwi.h  |   37 ++
>  drivers/scsi/pm8001/pm8001_init.c |   30 +
>  drivers/scsi/pm8001/pm8001_sas.h  |    3
>  4 files changed, 613 insertions(+), 41 deletions(-)
> 
> Please see enclosed attachment
> 
> 
> ______________________________________________________________________
> This email may contain privileged or confidential information, which
should
> only be used for the purpose for which it was sent by Xyratex. No further
rights
> or licenses are granted to use such information. If you are not the
intended
> recipient of this message, please notify the sender by return and delete
it.
> You may not use, copy, disclose or rely on the information contained in
it.
> 
> Internet email is susceptible to data corruption, interception and
> unauthorised amendment for which Xyratex does not accept liability. While
we
> have taken reasonable precautions to ensure that this email is free of
viruses,
> Xyratex does not accept liability for the presence of any computer viruses
in
> this email, nor for any losses caused as a result of viruses.
> 
> Xyratex Technology Limited (03134912), Registered in England & Wales,
> Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
> 
> The Xyratex group of companies also includes, Xyratex Ltd, registered in
> Bermuda, Xyratex International Inc, registered in California, Xyratex
> (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co
Ltd
> registered in The People's Republic of China and Xyratex Japan Limited
> registered in Japan.
> ______________________________________________________________________
> 
> 


