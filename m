From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCHv2 0/7] Limit overall SCSI EH runtime
Date: Mon, 1 Jul 2013 16:55:46 -0400
Message-ID: <20130701205546.GB10645@logfs.org>
References: <1372661455-122384-1-git-send-email-hare@suse.de>
 <20130701174423.GA10645@logfs.org>
 <1372706605.2385.37.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59705 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3GAW0Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jul 2013 18:26:24 -0400
Content-Disposition: inline
In-Reply-To: <1372706605.2385.37.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Bart van Assche <bvanassche@acm.org>

On Mon, 1 July 2013 19:23:25 +0000, James Bottomley wrote:
> On Mon, 2013-07-01 at 13:44 -0400, J=C3=B6rn Engel wrote:
> > If a single device is bad, don't ever do a host
> > reset.
>=20
> This isn't a tenable position.  Sometimes a device looks bad because =
the
> host state for it has gone insane.  At that point, the only safe acti=
on
> is a reset of the host to sane state.
>=20
> I could be persuaded that you should never do the transport equivalen=
t
> of a bus reset (on non-SPI transports, at least), which is actually h=
ard
> to do on some of the modern transports, but I don't think you can get
> away without having a host reset in the eh arsenal.

=46air enough.  Hardware being hardware and hardware bugs being hard to
fix, I see your point.

However, we shouldn't screw the poor user who has paid a premium for a
second HBA to get some redundancy and reset both of them at the same
time.  That would, you know, defeat the redundancy. ;)

J=C3=B6rn

--
A victorious army first wins and then seeks battle.
-- Sun Tzu
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
