From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] scsi_lib: add NULL check to scsi_setup_blk_pc_cmnd
Date: Wed, 25 Jul 2012 15:13:57 -0400
Message-ID: <20120725191357.GA28115@logfs.org>
References: <20120723173220.GA17767@logfs.org>
 <1343072755.5865.1.camel@dabdike>
 <20120723192439.GB17767@logfs.org>
 <1343106101.3513.0.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:54018 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab2GYU1k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2012 16:27:40 -0400
Content-Disposition: inline
In-Reply-To: <1343106101.3513.0.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 24 July 2012 09:01:41 +0400, James Bottomley wrote:
> On Mon, 2012-07-23 at 15:24 -0400, J=C3=B6rn Engel wrote:
> > On Mon, 23 July 2012 23:45:55 +0400, James Bottomley wrote:
> > >=20
> > > Have you checked this with the patches in scsi-misc?  There's a s=
eries
> > > of patches in there that alters the way sdev handling is done.
> >=20
> > I would have liked to, but the tree referenced in MAINTAINERS does =
not
> > appear to exist:
> >=20
> > git clone git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-m=
isc-2.6.git
> > Cloning into 'scsi-misc-2.6'...
> > fatal: The remote end hung up unexpectedly
>=20
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
>=20
> use the misc branch

joern@Sligo:/usr/src/kernel$ git clone --reference git/ git://git.kerne=
l.org/pub/scm/linux/kernel/git/jejb/scsi.git
Cloning into 'scsi'...
remote: Counting objects: 869, done.
remote: Compressing objects: 100% (420/420), done.
remote: Total 668 (delta 562), reused 274 (delta 248)
Receiving objects: 100% (668/668), 112.59 KiB, done.
Resolving deltas: 100% (562/562), completed with 110 local objects.
Checking out files: 100% (39127/39127), done.
joern@Sligo:/usr/src/kernel$ cd scsi/
joern@Sligo:/usr/src/kernel/scsi$ git branch
* master

Normally I never use branches, so there is a chance that I'm just
clueless.  But to my untrained eye, this looks as if there is no misc
branch.

J=C3=B6rn

--
To my face you have the audacity to advise me to become a thief - the w=
orst
kind of thief that is conceivable, a thief of spiritual things, a thief=
 of
ideas! It is insufferable, intolerable!
-- M. Binet in Scarabouche
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
