From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][SCSI] 53c700: Use proper debug printk format specifiers
Date: Mon, 20 Jun 2016 22:02:47 -0400
Message-ID: <yq1vb1347ug.fsf@sermon.lab.mkp.net>
References: <20160610203945.GA18046@p100.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <20160610203945.GA18046@p100.box> (Helge Deller's message of
	"Fri, 10 Jun 2016 22:39:45 +0200")
Sender: linux-parisc-owner@vger.kernel.org
To: Helge Deller <deller@gmx.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Helge" =3D=3D Helge Deller <deller@gmx.de> writes:

Helge> When enabling the debug options NCR_700_DEBUG and
Helge> NCR_700_TAG_DEBUG various printk format warnings can be seen
Helge> like: drivers/scsi/53c700.c:357:2: warning: format =E2=80=98%p=E2=
=80=99 expects
Helge> argument of type =E2=80=98void *=E2=80=99, but argument 4 has ty=
pe =E2=80=98dma_addr_t=E2=80=99
Helge> [-Wformat=3D] script_patch_32(hostdata->dev, script,
Helge> MessageLocation,

Helge> Fix them by using the right printk format specifiers.

Applied to 4.8/scsi-queue.

--=20
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-parisc"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
