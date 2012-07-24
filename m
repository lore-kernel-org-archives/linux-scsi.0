From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_lib: add NULL check to scsi_setup_blk_pc_cmnd
Date: Tue, 24 Jul 2012 09:01:41 +0400
Message-ID: <1343106101.3513.0.camel@dabdike>
References: <20120723173220.GA17767@logfs.org>
	 <1343072755.5865.1.camel@dabdike> <20120723192439.GB17767@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42665 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141Ab2GXFBs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2012 01:01:48 -0400
In-Reply-To: <20120723192439.GB17767@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2012-07-23 at 15:24 -0400, J=C3=B6rn Engel wrote:
> On Mon, 23 July 2012 23:45:55 +0400, James Bottomley wrote:
> > On Mon, 2012-07-23 at 13:32 -0400, J=C3=B6rn Engel wrote:
> > > At least two slightly different paths can lead to a NULL pointer
> > > dereference in scsi_prep_state_check and have been hit in practic=
e.
> >=20
> > Have you checked this with the patches in scsi-misc?  There's a ser=
ies
> > of patches in there that alters the way sdev handling is done.
>=20
> I would have liked to, but the tree referenced in MAINTAINERS does no=
t
> appear to exist:
>=20
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-mis=
c-2.6.git
> Cloning into 'scsi-misc-2.6'...
> fatal: The remote end hung up unexpectedly

git clone git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git

use the misc branch

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
