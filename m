From: Kai Makisara <Kai.Makisara@metla.fi>
Subject: Re: [BK PATCH] SCSI update for 2.6.3
Date: Tue, 24 Feb 2004 09:30:01 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0402240919490.1129@spektro.metla.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bambu.metla.fi ([128.214.53.7]:48011 "EHLO bambu.metla.fi")
	by vger.kernel.org with ESMTP id S262194AbUBXHaQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 02:30:16 -0500
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, kai.makisara@kolumbus.fi

On Tue, 24 Feb 2004, Linus Torvalds wrote:
>On Mon, 23 Feb 2004, James Bottomley wrote:
>>
>> Kai M=E4kisara:
>> o Sysfs class support for SCSI tapes
>
>Has this been checked for correctness, or will Al flame me to a crisp =
for
>accepting it? Pls verify..

It is using the class_simple interface Greg KH said can be used without
changes to driver's lifetime rules. If this is not true, then I have to
rework the patch. The code was posted to linux-scsi on Feb 5 but I woul=
d
not count on any serious review being done there.

	Kai
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
