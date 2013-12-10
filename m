From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Subject: RE: pm8001 issue
Date: Tue, 10 Dec 2013 13:25:27 +0000
Message-ID: <CE2C58F938F4C44EA74FFF880BAA7E5E1C687409@BBYEXM01.pmc-sierra.internal>
References: <DUB109-W96A382886123231F1B89A2B8D20@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:36023 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511Ab3LJNZ3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Dec 2013 08:25:29 -0500
In-Reply-To: <DUB109-W96A382886123231F1B89A2B8D20@phx.gbl>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Niall Drievers <nialler17@hotmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Niall,

Please update the firmware from http://www.adaptec.com/en-us/support/sa=
s/#sas_raid Adaptec Series 7 SAS/SATA 6 Gb - Host Bus Adapter section b=
ased on your card.

What is the current firmware version? You can get from the sys file "fw=
_version" under /sys/devices.
Can you please try checking with different pm80xx HBA card if you have?

Regards,
Suresh

-----Original Message-----
=46rom: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org] On Behalf Of Niall Drievers
Sent: Tuesday, December 10, 2013 2:51 PM
To: linux-scsi@vger.kernel.org
Subject: pm8001 issue

Hi,=A0

I've recently been trying install Linux on to a piece of hardware I pic=
ked up and I've noticed this error in the dmesg output when the kernel =
is loading. The error can be produced in version 0.1.36 and 0.1.37 of t=
he pm8001 module. I was hoping that when I updated it, I might be able =
to resolve it, but alas. My knowledge of MPI is rather limited and I wa=
s hoping someone might be able to point me in the right direction with =
regards to tackling this... increasing the max wait count, changing the=
 firmware, etc?


[ =A0 23.874307] mpi_uninit_check 663:TIMEOUT:IBDB value/=3D0x2 [ =A0 2=
3.937847] soft_reset_ready_check 697:MPI state is not ready [ =A0 24.00=
6578] pm8001_chip_soft_rst 761:FW is not ready [ =A0 26.449013] pm8001_=
chip_init 609:Firmware is not ready!


Regards,

Niall 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n the body of a message to majordomo@vger.kernel.org More majordomo inf=
o at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
