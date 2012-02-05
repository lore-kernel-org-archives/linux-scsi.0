From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 0/4] [SCSI] ufshcd: UFS Host Controller Driver
Date: Mon, 6 Feb 2012 07:45:03 +0900
Message-ID: <CAKYAXd_msUdB2UbMvxqn751nuN5R=T6W5sjLDMxqEOR6KTX38w@mail.gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
	<CAKYAXd_sRKCfw_rNrRD8yKKQEP_8Zee+E5rZW0G1NuuCA4HcNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKYAXd_sRKCfw_rNrRD8yKKQEP_8Zee+E5rZW0G1NuuCA4HcNA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Yaraganavi <santoshsy@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, arnd@arndb.de, venkat@linaro.org, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com
List-Id: linux-scsi@vger.kernel.org

2012/2/5 Namjae Jeon <linkinjeon@gmail.com>:
> 2012/2/2 Vinayak Holikatti <vinholikatti@gmail.com>:
>> From: Santosh Yaraganavi <santoshsy@gmail.com>
>>
>> UFS is designed to be the most advanced specification for
>> both embedded and removable flash memory-based storage in mobile dev=
ices
>> such as smart phones and tablet computers. =C2=A0The UFS standard re=
presents
>> an evolutionary progression of JEDEC standards in this field, and ha=
s been
>> specifically tailored for mobile applications and computing systems =
requiring
>> high performance and low power consumption. =C2=A0The initial data t=
hroughput for
>> UFS will be ~300 megabytes per second (MB/s), and the standard also =
supports
>> command queuing features to raise random read/write speeds.
>>
>> To achieve the highest performance and most power efficient data
>> transport, UFS uses the leading industry interface standards to form=
 its
>> Interconnect Layer: MIPI=C2=AE Alliance=E2=80=99s M-PHY and UniProSM=
 =C2=A0specifications.
>> UniPro is a comprehensive specification meant to act as a universal
>> chip-to-chip protocol, providing a common tunnel for other protocols=
=2E
>> The M-PHY interface is designed as the primary physical interface (P=
HY layer)
>> for the UniPro specification, and is a high speed serial interface t=
argeting
>> up to 2.9 gigabits per second (Gbps) per lane with up-scalability to=
 5.8Gbps
>> per lane.
>>
>> MIPI=E2=80=99s M-PHY and UniPro specifications are optimized for mob=
ile applications,
>> and are designed from the ground up for efficient power management i=
n mobile
>> devices, including enabling efficient transitions between the active=
 and power
>> save modes. Combined with a low active power level and a near-zero i=
dle power
>> level, UFS offers the promise for significant reductions in device p=
ower
>> consumption.
>>
>> The UFS standard adopts the well-known SCSI Architecture Model and c=
ommand
>> protocols supporting multiple commands with command queuing features=
 and
>> enabling a multi-thread programming paradigm. This differs from conv=
entional
>> flash-based memory cards and embedded flash solutions which process =
one
>> command at a time, limiting random read/write access performance.
>> In addition, a forthcoming complementary UFS Host Controller Interfa=
ce (HCI)
>> specification will allow system designers greater flexibility by sim=
plifying
>> the involvement of the host processor in the operation of the flash =
storage
>> subsystem. The UFS HCI specification and the adoption of SCSI will p=
rovide
>> a well-known software programming model and enable wider market adop=
tion.
>>
>> This patchset contains PCIe based UFS host controller driver which c=
omplies
>> to UFSHCI 1.0 and 1.1. The driver is based on Linux SCSI framework.
>> The driver is tested with UFS Host controller(FPGA) and UFS device(F=
PGA).
>>
>> This patch set is successfully applied on kernel version 3.3-rc2.
>>
>> Santosh Yaraganavi (4):
>> =C2=A0[SCSI] ufshcd: UFS Host controller driver
>> =C2=A0[SCSI] ufshcd: UFS UTP Transfer requests handling
>> =C2=A0[SCSI] ufshcd: UFSHCI error handling
>> =C2=A0[SCSI] ufshcd: SCSI error handling
>>
>> =C2=A0drivers/scsi/Kconfig =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A01 +
>> =C2=A0drivers/scsi/Makefile =C2=A0 =C2=A0 | =C2=A0 =C2=A01 +
>> =C2=A0drivers/scsi/ufs/Kconfig =C2=A0| =C2=A0 49 ++
>> =C2=A0drivers/scsi/ufs/Makefile | =C2=A0 =C2=A02 +
>> =C2=A0drivers/scsi/ufs/ufs.h =C2=A0 =C2=A0| =C2=A0203 +++++
>> =C2=A0drivers/scsi/ufs/ufshcd.c | 1954 +++++++++++++++++++++++++++++=
++++++++++++++++
>> =C2=A0drivers/scsi/ufs/ufshci.h | =C2=A0360 +++++++++
>> =C2=A07 files changed, 2570 insertions(+), 0 deletions(-)
>> =C2=A0create mode 100644 drivers/scsi/ufs/Kconfig
>> =C2=A0create mode 100644 drivers/scsi/ufs/Makefile
>> =C2=A0create mode 100644 drivers/scsi/ufs/ufs.h
>> =C2=A0create mode 100644 drivers/scsi/ufs/ufshcd.c
>> =C2=A0create mode 100644 drivers/scsi/ufs/ufshci.h
>>
>> --
>> 1.7.5.4
> Hi.
> I have been waiting for ufs contribution.
> Unfortunately I don't have real target supported ufs(maybe only you
> have it). I can not debug and run this code, So just review only code
> with specification.
>>
Hi. Santosh.
Would you share performance measurement result (read/write seq,ran) ?
Thanks.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kern=
el" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
