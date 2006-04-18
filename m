From: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Subject: RE: HEADS UP for gdth driver users
Date: Tue, 18 Apr 2006 16:41:02 +0200
Message-ID: <EF6AF37986D67948AD48624A3E5D93AFAA95FD@mtce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw2.adaptec.com ([216.52.22.42]:30181 "EHLO
	aimspam2.adaptec.com") by vger.kernel.org with ESMTP
	id S932154AbWDROlE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2006 10:41:04 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi all,

The patch looks good for 2.6.17-rc1. Christoph, did you already make th=
e second patch for the real switchover?=20
Will only the scsi_allocate_request()/scsi_do_req()/scsi_release_reques=
t() be removed in the next kernel releases? - I'm wondering if I could =
use the scsi_get_command()/scsi_put_command() functions to get a Scsi_C=
mnd struct. and to send it to the gdth_queuecommand()/gdth_next(). I'm =
willing to make and test the second patch but please give me some hints=
 what functions you plan to kill and what function we can still use.=20

Thanks & Regards,
Achim=20

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
