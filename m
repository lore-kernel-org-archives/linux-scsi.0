From: Niall Drievers <nialler17@hotmail.com>
Subject: pm8001 issue
Date: Tue, 10 Dec 2013 09:20:36 +0000
Message-ID: <DUB109-W96A382886123231F1B89A2B8D20@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dub0-omc4-s31.dub0.hotmail.com ([157.55.2.106]:30442 "EHLO
	dub0-omc4-s31.dub0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980Ab3LJJUi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Dec 2013 04:20:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi,=A0

I've recently been trying install Linux on to a piece of hardware I pic=
ked up and I've noticed this error in the dmesg output when the kernel =
is loading. The error can be produced in version 0.1.36 and 0.1.37 of t=
he pm8001 module. I was hoping that when I updated it, I might be able =
to resolve it, but alas. My knowledge of MPI is rather limited and I wa=
s hoping someone might be able to point me in the right direction with =
regards to tackling this... increasing the max wait count, changing the=
 firmware, etc?


[ =A0 23.874307] mpi_uninit_check 663:TIMEOUT:IBDB value/=3D0x2
[ =A0 23.937847] soft_reset_ready_check 697:MPI state is not ready
[ =A0 24.006578] pm8001_chip_soft_rst 761:FW is not ready
[ =A0 26.449013] pm8001_chip_init 609:Firmware is not ready!


Regards,

Niall 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
