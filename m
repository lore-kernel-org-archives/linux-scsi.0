From: =?windows-1252?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH]: add debug flag parameter for SCSI tape driver
Date: Wed, 11 Jun 2014 21:03:15 +0300
Message-ID: <1CAC495F-3A9A-45B1-8E15-4B6D3F17114D@kolumbus.fi>
References: <101311718.17236924.1402433475036.JavaMail.zimbra@redhat.com> <1374689615.17272341.1402444113231.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs16.mail.saunalahti.fi ([62.142.117.197]:51463 "EHLO
	vs16.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaFKSTY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 14:19:24 -0400
In-Reply-To: <1374689615.17272341.1402444113231.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org


On 11.6.2014, at 2.48, Laurence Oberman <loberman@redhat.com> wrote:

> Hello
>=20
> Take 2 of this patch, changed module description and subject line.
>=20
> This patch adds a debug_flag parameter that can be set on module load=
, and allows the DEBUG facility without a module recompile.
> Usage: mpdprobe st debug_flag=3D1
>=20
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
>=20

What is wrong with the existing methods to control debugging? You can e=
nable and disable debugging for each device with ioctl() (as described =
in the driver documentation). You can use mt-st to do this from command=
 line.

Your patch just allows one to change the default for all devices. The r=
eal problem may be that the distributions don=92t compile the debugging=
 code into the drivets but your patch does not change this.

Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
