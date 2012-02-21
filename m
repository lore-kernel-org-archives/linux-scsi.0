From: Candid Shot <candid_shot_1@yahoo.com>
Subject: scsi (sg) device status vs FC connectivity
Date: Tue, 21 Feb 2012 13:35:07 -0800 (PST)
Message-ID: <1329860107.22873.YahooMailNeo@web46407.mail.sp1.yahoo.com>
Reply-To: Candid Shot <candid_shot_1@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm19.bullet.mail.sp2.yahoo.com ([98.139.91.89]:41153 "HELO
	nm19.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753033Ab2BUVfI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2012 16:35:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

(I hope this list is the right place to ask SG Driver related question =
=2E.)

Background: A FC cable-pull is simulated by disabling the FC switch (Br=
ocade) port.


While /sys/class/fc_host/hostx/port_state might confirm the FC connecti=
vity is missing,

/proc/scsi/sg/devices will show the scsi device to be 'online'.

My goal is to be able to return an error to the application, should a c=
able-pull happen.

Is there a way to be able to tweak this behavior where the scsi driver =
is able to look at port events,
and possibly return errors during read/write operations?=A0

Thanks,
Raj.

Platform: =A0=A0Adapter: EMC LPe12002-E 8Gb 2-port PCIe Fibre Channel A=
dapter on PCI
=A0 =A0 =A0 =A0 =A0 =A0 Server: =A0Linux ostqa-media3a.sie.hds.com 2.6.=
18-238.el5 #1 SMP Sun Dec 19 14:22:44 EST 2010 x86_64 x86_64 x86_64 GNU=
/Linux
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
