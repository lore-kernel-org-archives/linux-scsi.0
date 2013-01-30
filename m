From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: mpt2sas: device_blocked question
Date: Wed, 30 Jan 2013 12:22:29 +0530
Message-ID: <DCD177647606E9419ED923E0C8C4AA7223E770D416@inbmail02.lsi.com>
References: <20130123212033.GA15800@logfs.org>,
 <87k3r310jr.fsf@nemi.mork.no>, <20130125171255.GA22141@logfs.org>,
 <20130125180044.GC22141@logfs.org>, <20130125192039.GE22141@logfs.org>
 <201301261152058902951@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:58345 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408Ab3A3Gwj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2013 01:52:39 -0500
In-Reply-To: <201301261152058902951@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "spren.gm@gmail.com" <spren.gm@gmail.com>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, Support <support@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Spren,

Reason code MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING mean that "A ta=
rget device has stopped responding or is missing but the ReportDeviceMi=
ssingDelay timer has not expired for this device".

Can you please send me the some more information i.e.

 1. For which operation/TestCase this issue has occurred?
 2. Which Driver & Firmware version you are using?
 3. Can you also please send me the complete log.

Thanks,
Sreekanth.

-----Original Message-----
=46rom: spren.gm@gmail.com [mailto:spren.gm@gmail.com]=20
Sent: Saturday, January 26, 2013 9:22 AM
To: J=F6rnEngel; Bj=F8rnMork; Nandigama, Nagalakshmi; Reddy, Sreekanth;=
 Support; James E.J. Bottomley; DL-MPT Fusion Linux
Cc: linux-scsi@vger.kernel.org
Subject: mpt2sas: device_blocked question

Hi,
  we encounter a problem that a disk is blocked forever, the key log is=
:

mpt2sas0: TEST_UNIT_READY: handle(0x000a), lun(0)
mpt2sas0: TEST_UNIT_READY: handle(0x000a), lun(0)
mpt2sas0: Spinning up disk.... handle(0x000a), lun(0)
mpt2sas0: TEST_UNIT_READY: handle(0x000a), lun(0)
mpt2sas0: Spinning up disk.... handle(0x000a), lun(0)
mpt2sas0: TEST_UNIT_READY: handle(0x000a), lun(0)
mpt2sas0: Spinning up disk.... handle(0x000a), lun(0) sd 2:0:1:0: devic=
e_blocked, handle(0x000a)

  looking into the driver code, it seems that the device is blocked by =
function
_scsih_block_io_to_children_attached_directly() in mpt2sas/mpt2sas_scsi=
h.c with reason_code =3D=3D MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING=
,
  what does this reason_code mean please? when should it be returned? a=
nd any way to handle it?

Best Regards,
spren
2013-01-26

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
