From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] scsi_lib: add NULL check to scsi_setup_blk_pc_cmnd
Date: Mon, 23 Jul 2012 15:24:39 -0400
Message-ID: <20120723192439.GB17767@logfs.org>
References: <20120723173220.GA17767@logfs.org>
 <1343072755.5865.1.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:54355 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab2GWUiZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jul 2012 16:38:25 -0400
Content-Disposition: inline
In-Reply-To: <1343072755.5865.1.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 23 July 2012 23:45:55 +0400, James Bottomley wrote:
> On Mon, 2012-07-23 at 13:32 -0400, J=C3=B6rn Engel wrote:
> > At least two slightly different paths can lead to a NULL pointer
> > dereference in scsi_prep_state_check and have been hit in practice.
>=20
> Have you checked this with the patches in scsi-misc?  There's a serie=
s
> of patches in there that alters the way sdev handling is done.

I would have liked to, but the tree referenced in MAINTAINERS does not
appear to exist:

git clone git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-=
2.6.git
Cloning into 'scsi-misc-2.6'...
fatal: The remote end hung up unexpectedly

J=C3=B6rn

--
The object-oriented version of 'Spaghetti code' is, of course, 'Lasagna=
 code'.
(Too many layers).
-- Roberto Waltman.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
