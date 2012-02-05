From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 0/4] [SCSI] ufshcd: UFS Host Controller Driver
Date: Sun, 5 Feb 2012 16:20:47 +0900
Message-ID: <CAKYAXd_sRKCfw_rNrRD8yKKQEP_8Zee+E5rZW0G1NuuCA4HcNA@mail.gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, arnd@arndb.de, venkat@linaro.org, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, Santosh Yaraganavi <santoshsy@gmail.com>
List-Id: linux-scsi@vger.kernel.org

2012/2/2 Vinayak Holikatti <vinholikatti@gmail.com>:
> From: Santosh Yaraganavi <santoshsy@gmail.com>
>
> UFS is designed to be the most advanced specification for
> both embedded and removable flash memory-based storage in mobile devi=
ces
> such as smart phones and tablet computers. =C2=A0The UFS standard rep=
resents
> an evolutionary progression of JEDEC standards in this field, and has=
 been
> specifically tailored for mobile applications and computing systems r=
equiring
> high performance and low power consumption. =C2=A0The initial data th=
roughput for
> UFS will be ~300 megabytes per second (MB/s), and the standard also s=
upports
> command queuing features to raise random read/write speeds.
>
> To achieve the highest performance and most power efficient data
> transport, UFS uses the leading industry interface standards to form =
its
> Interconnect Layer: MIPI=C2=AE Alliance=E2=80=99s M-PHY and UniProSM =
=C2=A0specifications.
> UniPro is a comprehensive specification meant to act as a universal
> chip-to-chip protocol, providing a common tunnel for other protocols.
> The M-PHY interface is designed as the primary physical interface (PH=
Y layer)
> for the UniPro specification, and is a high speed serial interface ta=
rgeting
> up to 2.9 gigabits per second (Gbps) per lane with up-scalability to =
5.8Gbps
> per lane.
>
> MIPI=E2=80=99s M-PHY and UniPro specifications are optimized for mobi=
le applications,
> and are designed from the ground up for efficient power management in=
 mobile
> devices, including enabling efficient transitions between the active =
and power
> save modes. Combined with a low active power level and a near-zero id=
le power
> level, UFS offers the promise for significant reductions in device po=
wer
> consumption.
>
> The UFS standard adopts the well-known SCSI Architecture Model and co=
mmand
> protocols supporting multiple commands with command queuing features =
and
> enabling a multi-thread programming paradigm. This differs from conve=
ntional
> flash-based memory cards and embedded flash solutions which process o=
ne
> command at a time, limiting random read/write access performance.
> In addition, a forthcoming complementary UFS Host Controller Interfac=
e (HCI)
> specification will allow system designers greater flexibility by simp=
lifying
> the involvement of the host processor in the operation of the flash s=
torage
> subsystem. The UFS HCI specification and the adoption of SCSI will pr=
ovide
> a well-known software programming model and enable wider market adopt=
ion.
>
> This patchset contains PCIe based UFS host controller driver which co=
mplies
> to UFSHCI 1.0 and 1.1. The driver is based on Linux SCSI framework.
> The driver is tested with UFS Host controller(FPGA) and UFS device(FP=
GA).
>
> This patch set is successfully applied on kernel version 3.3-rc2.
>
> Santosh Yaraganavi (4):
> =C2=A0[SCSI] ufshcd: UFS Host controller driver
> =C2=A0[SCSI] ufshcd: UFS UTP Transfer requests handling
> =C2=A0[SCSI] ufshcd: UFSHCI error handling
> =C2=A0[SCSI] ufshcd: SCSI error handling
>
> =C2=A0drivers/scsi/Kconfig =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A01 +
> =C2=A0drivers/scsi/Makefile =C2=A0 =C2=A0 | =C2=A0 =C2=A01 +
> =C2=A0drivers/scsi/ufs/Kconfig =C2=A0| =C2=A0 49 ++
> =C2=A0drivers/scsi/ufs/Makefile | =C2=A0 =C2=A02 +
> =C2=A0drivers/scsi/ufs/ufs.h =C2=A0 =C2=A0| =C2=A0203 +++++
> =C2=A0drivers/scsi/ufs/ufshcd.c | 1954 ++++++++++++++++++++++++++++++=
+++++++++++++++
> =C2=A0drivers/scsi/ufs/ufshci.h | =C2=A0360 +++++++++
> =C2=A07 files changed, 2570 insertions(+), 0 deletions(-)
> =C2=A0create mode 100644 drivers/scsi/ufs/Kconfig
> =C2=A0create mode 100644 drivers/scsi/ufs/Makefile
> =C2=A0create mode 100644 drivers/scsi/ufs/ufs.h
> =C2=A0create mode 100644 drivers/scsi/ufs/ufshcd.c
> =C2=A0create mode 100644 drivers/scsi/ufs/ufshci.h
>
> --
> 1.7.5.4
Hi.
I have been waiting for ufs contribution.
Unfortunately I don't have real target supported ufs(maybe only you
have it). I can not debug and run this code, So just review only code
with specification.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
