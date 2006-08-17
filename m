From: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Subject: Re: qlogic 2312 problems on 2.6.16.22, 2.6.18rc4
Date: Thu, 17 Aug 2006 07:58:19 +0200
Message-ID: <200608170758.19344.arekm@pld-linux.org>
References: <200608140946.50411.arekm@pld-linux.org> <200608162310.26541.arekm@pld-linux.org> <20060816221751.GW3674@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outgoing3.smtp.agnat.pl ([193.239.44.85]:37533 "EHLO
	outgoing3.smtp.agnat.pl") by vger.kernel.org with ESMTP
	id S1750792AbWHQF60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2006 01:58:26 -0400
In-Reply-To: <20060816221751.GW3674@andrew-vasquezs-computer.local>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thursday 17 August 2006 00:17, Andrew Vasquez wrote:

> > I started dd'ing text file onto /dev/sda2, then back to tmpfs and d=
iffing
> > these. Corruption is one byte, several not corrupted bytes and agai=
n one
> > corrupted byte. Some regular pattern.
>
> Could you send me the a snippet (2 to 4KB) of the good and bad data?

The corruption doesn't happen so often. I need 1MB of data to see 5 byt=
es=20
corrupted.

[root@pldmachine ~]# dd if=3Dxok of=3D/dev/sda2 bs=3D1M count=3D1
1+0 records in
1+0 records out
[root@pldmachine ~]# dd if=3D/dev/sda2 of=3Dtry1 bs=3D1M count=3D1
1+0 records in
1+0 records out
[root@pldmachine ~]# dd if=3D/dev/sda2 of=3Dtry2 bs=3D1M count=3D1
1+0 records in
1+0 records out
[root@pldmachine ~]# dd if=3D/dev/sda2 of=3Dtry3 bs=3D1M count=3D1
1+0 records in
1+0 records out

results http://ep09.pld-linux.org/~arekm/qlogic/

>
> Regards,
> Andrew Vasquez

--=20
Arkadiusz Mi=B6kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
