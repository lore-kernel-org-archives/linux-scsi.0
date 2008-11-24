From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH] scsi_dh: Adding LSI vendor and product ids
	in rdac device list
Date: Mon, 24 Nov 2008 08:06:11 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF45C92436A@cosmail01.lsi.com>
References: <1225944321.14830.1109.camel@chandra-ubuntu>
	<E463DF2B2E584B4A82673F53D62C2EF45BE75982@cosmail01.lsi.com>
	<1227485085.25499.5.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1227485085.25499.5.camel@localhost.localdomain>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: device-mapper development <dm-devel@redhat.com>, "andmike@linux.vnet.ibm.com" <andmike@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Thank You..  Will take care next time.

Thanks
Babu Moger
-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
Sent: Sunday, November 23, 2008 6:05 PM
To: Moger, Babu
Cc: linux-scsi@vger.kernel.org; sekharan@us.ibm.com; andmike@linux.vnet.i=
bm.com; device-mapper development
Subject: Re: [PATCH] scsi_dh: Adding LSI vendor and product ids in rdac d=
evice list

On Mon, 2008-11-10 at 16:17 -0700, Moger, Babu wrote:
> From: Babu Moger <babu.moger@lsi.com>
>
> This patch adds LSI vendor and product ids in rdac device handler.
>
> Signed-off-by: Babu Moger <Babu.Moger@lsi.com>
>
> ---
>
> --- linux-2.6.28-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c.orig   =
 2008-11-10 16:56:01.000000000 -0600
> +++ linux-2.6.28-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c 2008-11=
-10 16:56:20.000000000 -0600
> @@ -594,6 +594,8 @@ static const struct scsi_dh_devlist rdac
>         {"SUN", "LCSM100_F"},
>         {"DELL", "MD3000"},
>         {"DELL", "MD3000i"},
> +       {"LSI", "INF-01-00"},
> +       {"ENGENIO", "INF-01-00"},
>         {NULL, NULL},
>  };

This patch is whitespace damaged.  Your tabs have been converted to
spaces by your email tool.  I've fixed it up this time, since it was
only two lines, but please see

Documentation/email-clients.txt

For hints on how to get your MUA to work with patches.

James
