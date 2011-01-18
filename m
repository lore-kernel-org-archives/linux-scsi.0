From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH] [SCSI] megaraid_sas: Sanity check user supplied length before passing it to dma_alloc_coherent()
Date: Tue, 18 Jan 2011 22:46:24 +0100
Message-ID: <8739op51hr.fsf@nemi.mork.no>
References: <1289498526-22589-1-git-send-email-bjorn@mork.no>
	<1291387026-23262-1-git-send-email-bjorn@mork.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:33101 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab1ARVqh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 16:46:37 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1PfJNs-0005na-Mn
	for linux-scsi@vger.kernel.org; Tue, 18 Jan 2011 22:46:36 +0100
Received: from nemi.mork.no ([148.122.252.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2011 22:46:36 +0100
Received: from bjorn by nemi.mork.no with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2011 22:46:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: megaraidlinux@lsi.com, "James E.J. Bottomley" <James.Bottomley@suse.de>, Bo.Yang@lsi.com

Bj=C3=B8rn Mork <bjorn@mork.no> writes:

> The ioc->sgl[i].iov_len value is supplied by the ioctl caller, and ca=
n be
> zero in some cases.  Assume that's valid and continue without error.
>
> Fixes (multiple individual reports of the same problem for quite a wh=
ile):
>
> http://marc.info/?l=3Dlinux-ide&m=3D128941801715301
> http://bugs.debian.org/604627
> http://www.mail-archive.com/linux-poweredge@dell.com/msg02575.html

ping?

I don't know how to interpret the total silence...  NAKing it is better
if you don't like the code.


Bj=C3=B8rn

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
