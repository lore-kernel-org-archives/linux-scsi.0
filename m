From: Orion Poplawski <orion@cora.nwra.com>
Subject: Re: MVSAS status
Date: Thu, 11 Feb 2010 18:30:23 +0000 (UTC)
Message-ID: <loom.20100211T192508-509@post.gmane.org>
References: <loom.20100210T002935-813@post.gmane.org> <73e903671002110150h3c4ae0dcq17625f6d9b545bf4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:38283 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311Ab0BKSay (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Feb 2010 13:30:54 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1NfdoP-0001le-Dz
	for linux-scsi@vger.kernel.org; Thu, 11 Feb 2010 19:30:50 +0100
Received: from inferno.cora.nwra.com ([65.44.101.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2010 19:30:49 +0100
Received: from orion by inferno.cora.nwra.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2010 19:30:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Kristleifur Da=C3=B0ason <kristleifur <at> gmail.com> writes:
> These cards have been recommended for ZFS use on Solaris backed with
> solid arguments, so the hardware is definitely fine [1].
>
> [1] -
http://jmlittle.blogspot.com/2008/06/recommended-disk-controllers-for-z=
fs.html

That article seems to refer to the old PCI-X Marvell 88SX60XX controlle=
rs,
which I'm using under linux.  Having some trouble with the 88SX5081, bu=
t the
6081 is fine.

Just booted the opensolard 2009.06 live cd and I'm not sure it detected=
 the
PCIe marvell card.  Very green with solaris, but I don't see anything p=
romising
in dmesg.

- Orion

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
