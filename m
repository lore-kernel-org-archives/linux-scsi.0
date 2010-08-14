From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] final scsi updates for the 2.6.36 merge window [possibly]
Date: Sat, 14 Aug 2010 12:40:16 -0700
Message-ID: <AANLkTinLrhfiW9e0Vn=p=tOT85V9bTpX8CTEVSMHSxjO@mail.gmail.com>
References: <1281814081.21641.11.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261Ab0HNTlK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Aug 2010 15:41:10 -0400
In-Reply-To: <1281814081.21641.11.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Sat, Aug 14, 2010 at 12:28 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
>
> =A0drivers/firmware/iscsi_boot_sysfs.c | =A0481 ---------------------=
---------------
> =A0drivers/scsi/iscsi_boot_sysfs.c =A0 =A0 | =A0481 +++++++++++++++++=
+++++++++++++++++++
> ...
> =A045 files changed, 1999 insertions(+), 851 deletions(-)

You really need to learn to use the -M (and --summary) flag. That's a
pure rename, and it should look like

 drivers/{firmware =3D> scsi}/iscsi_boot_sysfs.c |    0
 ...
 44 files changed, 1518 insertions(+), 370 deletions(-)
 rename drivers/{firmware =3D> scsi}/iscsi_boot_sysfs.c (100%)

which is a whole lot less changes.

                    Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
