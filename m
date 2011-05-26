From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 7/8] lpfc 8.3.24: debugfs additions for SLI4
Date: Thu, 26 May 2011 18:18:00 -0500
Message-ID: <1306451880.4048.71.camel@mulgrave.site>
References: <1306251883.948.2.camel@wookie>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58585 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756405Ab1EZXSH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2011 19:18:07 -0400
In-Reply-To: <1306251883.948.2.camel@wookie>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

On Tue, 2011-05-24 at 11:44 -0400, James Smart wrote:
> debugfs additions for new SLI interface

You guys need a newer compiler:

drivers/scsi/lpfc/lpfc_debugfs.c: In function =E2=80=98lpfc_debugfs_dum=
pHBASlim_data.clone.3=E2=80=99:
drivers/scsi/lpfc/lpfc_debugfs.c:412:1: warning: the frame size of 1036=
 bytes is larger than 1024 bytes
drivers/scsi/lpfc/lpfc_debugfs.c: In function =E2=80=98lpfc_idiag_drbac=
c_write=E2=80=99:
drivers/scsi/lpfc/lpfc_debugfs.c:2260:30: warning: =E2=80=98reg_val=E2=80=
=99 may be used uninitialized in this function

The reg_val problem looks to be just because the compiler can't work ou=
t
that one of the if () statements will always be true.

The stack overflow is the char buf[1024]

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
