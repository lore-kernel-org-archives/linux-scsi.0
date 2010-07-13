From: =?ISO-8859-1?Q?Kim_J=F8rgensen?= <kj@mocsystems.com>
Subject: ISCSI subenclosure support
Date: Tue, 13 Jul 2010 11:31:28 +0200
Message-ID: <4C3C3270.2050502@mocsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adam.mocsystems.com ([80.197.39.182]:49152 "EHLO
	adam.mocsystems.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab0GMKKF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2010 06:10:05 -0400
Received: from [192.168.111.208]
	by adam.mocsystems.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <kj@mocsystems.com>)
	id 1OYbsz-0006Zt-83
	for linux-scsi@vger.kernel.org; Tue, 13 Jul 2010 11:34:45 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have recently run into a snag with the Linux kernel.
It gives me an error when i try to connect a server to a sub-enclosure.
So, i dug through the code and found the FIXME message in the ses.c fil=
e.
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
blob;f=3Ddrivers/scsi/ses.c (Here on line: 538)

I have googled the best i have learned and can't find anybody else with=
 this problem, much less a solution/patch.

Is there anybody on the list that has any experience with this problem =
or who has a patch for it?
Or is there anybody who thinks they might be able to develop such a pat=
ch?

The equipment we are trying to connect to is a Dell MD3000i with an MD1=
000 subenclosure.

If there is a need for monetary compensation for the effort, i am sure =
something can be arranged.

We might be able to setup a testing environment to develop and test the=
 patch.


--=20
   -Kim J=F8rgensen-

   System Administrator
      MOC Systems
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
