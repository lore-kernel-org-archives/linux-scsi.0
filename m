From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Subject: Re: st driver doesn't seem to grok LTO partitioning (LTO-5 firmware
 upgrade)
Date: Mon, 25 Dec 2017 15:04:01 -0500
Message-ID: <20171225150401.047f2f7f@Vantage.cJ>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zougloub.eu ([69.70.16.42]:44704 "EHLO zougloub.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752667AbdLYUJd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Dec 2017 15:09:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, Laurence Oberman <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org

Hi,


This is just to state that I used the SAS LTO firmware upgrade method
Douglas suggested (1 year ago) and it worked fine, upgrading an HPE
LTO-5 Ultrium 3000 internal SAS tape drive from a .frm / .E file.


Best regards,

--=20
J=C3=A9r=C3=B4me

PS: It took me a while to find a way to get the latest firmware for
that drive, so here is some additional info: the Z6ED_019_233.E aka
LTT_Ultrium_5-SCSI_Z6ED_STANDALONE.frm firmware is available inside a
package not blocked by HPE paywall:
 https://downloads.hpe.com/pub/softlib2/software1/sc-windows/p368283668/v12=
4587/cp031432.exe
 https://support.hpe.com/hpsc/swd/public/detail?sp4ts.oid=3D7271242&swItemI=
d=3DMTX_afc26488547047b2b55cec874c&swEnvOid=3D4138#tab4
