From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
Subject: Re: 2.6.9 aacraid hangup
Date: Thu, 28 Oct 2004 00:42:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041027224238.GB2659@mail.muni.cz>
References: <60807403EABEB443939A5A7AA8A7458B40B79B@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:5792 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S262679AbUJ0Xjd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 19:39:33 -0400
Received: from hell.sks3.muni.cz (hell.sks3.muni.cz [147.251.210.30])
	by zeus.kernel.org (8.12.11/8.11.6) with ESMTP id i9RNXFL3016131
	for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2004 16:33:17 -0700
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B40B79B@otce2k01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Oct 22, 2004 at 08:33:57AM -0400, Salyzyn, Mark wrote:
> Those series of messages come from the Firmware and are just blindly =
printed
> by the driver. You have some `real' SCSI bus problems as the card nee=
ds to
> take corrective actions, I would suggest inspecting termination, cabl=
es and
> drives (see if one of them gets a LED stuck on before the problem cro=
ps up,
> stuff like that). One of those corrective actions is a controller cac=
he flush
> which may have tipped the scales on the scsi layer regarding timing o=
ut on the
> devices and taking them offline ...

Well, if someone has the same problem may be this is the same issue:
http://www.seagate.com/support/disc/u320_firmware.html

--=20
Luk=E1=B9 Hejtm=E1nek
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
