From: Adrian Bunk <bunk@stusta.de>
Subject: 2.6.18-rc1-mm2: drivers/scsi/NCR53C9x.c compile error
Date: Fri, 14 Jul 2006 21:08:13 +0200
Message-ID: <20060714190813.GC3633@stusta.de>
References: <20060713224800.6cbdbf5d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44295 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1422716AbWGNTIO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jul 2006 15:08:14 -0400
Content-Disposition: inline
In-Reply-To: <20060713224800.6cbdbf5d.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Thu, Jul 13, 2006 at 10:48:00PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.18-rc1-mm1:
>...
>  git-scsi-rc-fixes.patch
>...
>  git trees.
>...

Christoph, this is caused by your "hide EH backup data outside the scsi=
_cmnd"=20
patch:

<--  snip  -->

=2E..
  CC      drivers/scsi/NCR53C9x.o
drivers/scsi/NCR53C9x.c: In function =E2=80=98esp_get_dmabufs=E2=80=99:
drivers/scsi/NCR53C9x.c:914: error: =E2=80=98Scsi_Cmnd=E2=80=99 has no =
member named =E2=80=98buffer=E2=80=99
drivers/scsi/NCR53C9x.c: In function =E2=80=98esp_should_clear_sync=E2=80=
=99:
drivers/scsi/NCR53C9x.c:2156: error: =E2=80=98Scsi_Cmnd=E2=80=99 has no=
 member named =E2=80=98data_cmnd=E2=80=99
make[2]: *** [drivers/scsi/NCR53C9x.o] Error 1

<--  snip  -->
=20
cu
Adrian

--=20

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
