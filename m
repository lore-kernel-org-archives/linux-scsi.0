From: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Subject: RE: HEADS UP for gdth driver users
Date: Fri, 10 Mar 2006 12:04:41 +0100
Message-ID: <B51CDBDEB98C094BB6E1985861F53AF374EAED@nkse2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:39900 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S932724AbWCJLEp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2006 06:04:45 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

We are willing to test the changes. Could you please send the latest pa=
tch to me?=20

Thanks,
Achim Leubner

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Achim Leubner
Software Engineer / RAID drivers
ICP vortex GmbH / Adaptec Inc.
Phone: +49-351-8718291
=20
-----Original Message-----
=46rom: Christoph Hellwig [mailto:hch@lst.de]=20
Sent: Mittwoch, 8. M=E4rz 2006 14:20
To: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Leubner, =
Achim
Subject: HEADS UP for gdth driver users

Hi folks,

the gdth driver is the only driver using (and in this case abusing) the
scsi_request interface we plan to kill for 2.6.17.  I've sent a patch
that's a first step to convert the driver away from it a few weeks ago
but didn't get any response.  I urgently need testers to keep the drive=
r
for 2.6.17+.  Else it'll be marked broken until we get a person to help
testing the changes needed to resurrect it.


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
