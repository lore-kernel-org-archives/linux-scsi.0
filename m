From: "Smart, James" <James.Smart@Emulex.com>
Subject: RE: oss emulex linux driver : error report
Date: Thu, 18 Mar 2004 12:22:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF2802C0154A@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:2964 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S262790AbUCRRWl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2004 12:22:41 -0500
List-Id: linux-scsi@vger.kernel.org
To: "'christophe.varoqui@free.fr'" <christophe.varoqui@free.fr>
Cc: linux-scsi@vger.kernel.org

cvaroqui,

We believe this to be an issue with outdated firmware. Old firmware required
a special handshake that the current driver does not perform.  Please refer
to http://www.emulex.com/ts/dds.html for obtaining the lastest firmware.

Please contact me if you have any problems.

Thanks,

-- James S.


> -----Original Message-----
> From: christophe.varoqui@free.fr [mailto:christophe.varoqui@free.fr]
> Sent: Thursday, March 18, 2004 6:31 AM
> To: Smart, James
> Cc: linux-scsi@vger.kernel.org
> Subject: oss emulex linux driver : error report
> 
> 
> Hello,
> 
> I report a bad behaviour with a LP952 HBA :
> 06:02.0 Fibre Channel: Emulex Corporation LP952 Fibre Channel 
> Adapter (rev 01)
> 
> Symptoms in dmesg when insmod lpfcdd.ko :
> Emulex LightPulse FC SCSI 2.10c
> lpfc 0000:06:02.0: 0:0442:INe:Adapter failed to init, mbxCmd 
> x88 CONFIG_PORT,
> mbxStatus x12 Data: x0
> lpfc 0000:06:02.0: 0:0442:INe:Adapter failed to init, mbxCmd 
> x88 CONFIG_PORT,
> mbxStatus x12 Data: x0
> 
> The kernel is 2.6.3-mm1
> 
> regards,
> cvaroqui
> -- 
> 
