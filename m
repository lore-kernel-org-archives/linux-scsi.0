From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH]: add debug flag parameter for SCSI tape driver
Date: Wed, 11 Jun 2014 14:24:25 -0400 (EDT)
Message-ID: <664697763.17697275.1402511065048.JavaMail.zimbra@redhat.com>
References: <101311718.17236924.1402433475036.JavaMail.zimbra@redhat.com> <1374689615.17272341.1402444113231.JavaMail.zimbra@redhat.com> <1CAC495F-3A9A-45B1-8E15-4B6D3F17114D@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:57818 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaFKSYd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 14:24:33 -0400
In-Reply-To: <1CAC495F-3A9A-45B1-8E15-4B6D3F17114D@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai =?utf-8?Q?M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Kai,
Thank you for considering this.

With #define DEBUG 0
We still include

#define DEB(a)
#define DEBC(a)

With the debug_flag we then provide the needed debug I am looking for a=
t module load time.
But I agree that it enables it for all devices and that may not be opti=
mal
I don't change the default, I just allow the parameter to control it.

In the last few issues I have been working I have had to recompile and =
provide the st module to get what I needed captured for debugging so I =
decided to try the patch submission.

Thank You
Laurence

----- Original Message -----
=46rom: "Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi>
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org
Sent: Wednesday, June 11, 2014 2:03:15 PM
Subject: Re: [PATCH]: add debug flag parameter for SCSI tape driver


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
eal problem may be that the distributions don=E2=80=99t compile the deb=
ugging code into the drivets but your patch does not change this.

Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
