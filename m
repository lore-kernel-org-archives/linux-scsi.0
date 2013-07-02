From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCHv2 0/7] Limit overall SCSI EH runtime
Date: Tue, 2 Jul 2013 11:50:58 -0400
Message-ID: <20130702155058.GB19005@logfs.org>
References: <1372661455-122384-1-git-send-email-hare@suse.de>
 <20130701174423.GA10645@logfs.org>
 <1372706605.2385.37.camel@dabdike>
 <20130701205546.GB10645@logfs.org>
 <1372747024.2385.71.camel@dabdike>
 <20130702145809.GA19005@logfs.org>
 <1372782820.2821.18.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59718 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab3GBRVh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jul 2013 13:21:37 -0400
Content-Disposition: inline
In-Reply-To: <1372782820.2821.18.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Bart van Assche <bvanassche@acm.org>

On Tue, 2 July 2013 16:33:40 +0000, James Bottomley wrote:
> On Tue, 2013-07-02 at 10:58 -0400, J=C3=B6rn Engel wrote:
> > On Tue, 2 July 2013 06:37:05 +0000, James Bottomley wrote:
> > >=20
> > > I don't understand what you're getting at.  In a dual HBA situati=
on,
> > > whether the second HBA is implicated or not depends on configurat=
ion and
> > > what the first HBA is doing. If it's just passively lost device s=
tate,
> > > then the second HBA should continue just fine.  If the insane HBA=
 is
> >=20
> > If the problem is an insane drive instead of an insane HBA, both HB=
As
> > will be in roughly the same state at roughly the same time - assumi=
ng
> > they both send commands to the insane drive.  If they now go into
> > error handling and effectively shut off all the sane drives at roug=
hly
> > the same time, the user is ****ed.
>=20
> That's handled in device reset, so I don't understand your point.

Doesn't a device reset require all IO to the entire HBA to stop?
Hannes patches fixed that for aborts, but not for device reset yet,
afaics.

J=C3=B6rn

--
In America you can have either a flimsy box banged together out of two
by fours and drywall, or a McMansion -- a flimsy box banged together
out of two by fours and drywall, but larger, more dramatic-looking,
and full of expensive fittings.
-- Paul Graham
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
