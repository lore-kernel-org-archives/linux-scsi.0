From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 0/4] [SCSI] ufshcd: UFS Host Controller Driver
Date: Mon, 6 Feb 2012 12:47:57 +0530
Message-ID: <CALMYJDvy58ohVSjeQC2e=rccyKe2S=628q9YBFtpAm7v1HHO3Q@mail.gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
 <CAKYAXd_sRKCfw_rNrRD8yKKQEP_8Zee+E5rZW0G1NuuCA4HcNA@mail.gmail.com> <CAKYAXd_msUdB2UbMvxqn751nuN5R=T6W5sjLDMxqEOR6KTX38w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKYAXd_msUdB2UbMvxqn751nuN5R=T6W5sjLDMxqEOR6KTX38w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, arnd@arndb.de, venkat@linaro.org, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 6, 2012 at 4:15 AM, Namjae Jeon <linkinjeon@gmail.com> wrot=
e:
> 2012/2/5 Namjae Jeon <linkinjeon@gmail.com>:
>> 2012/2/2 Vinayak Holikatti <vinholikatti@gmail.com>:
>>> From: Santosh Yaraganavi <santoshsy@gmail.com>
>>>
>>> UFS is designed to be the most advanced specification for
>>> both embedded and removable flash memory-based storage in mobile de=
vices
>>> such as smart phones and tablet computers. =A0The UFS standard repr=
esents
>>> an evolutionary progression of JEDEC standards in this field, and h=
as been
>>> specifically tailored for mobile applications and computing systems=
 requiring
>>> high performance and low power consumption. =A0The initial data thr=
oughput for
>>> UFS will be ~300 megabytes per second (MB/s), and the standard also=
 supports
>>> command queuing features to raise random read/write speeds.
>>>
>>> To achieve the highest performance and most power efficient data
>>> transport, UFS uses the leading industry interface standards to for=
m its
>>> Interconnect Layer: MIPI=AE Alliance=92s M-PHY and UniProSM =A0spec=
ifications.
>>> UniPro is a comprehensive specification meant to act as a universal
>>> chip-to-chip protocol, providing a common tunnel for other protocol=
s.
>>> The M-PHY interface is designed as the primary physical interface (=
PHY layer)
>>> for the UniPro specification, and is a high speed serial interface =
targeting
>>> up to 2.9 gigabits per second (Gbps) per lane with up-scalability t=
o 5.8Gbps
>>> per lane.
>>>
>>> MIPI=92s M-PHY and UniPro specifications are optimized for mobile a=
pplications,
>>> and are designed from the ground up for efficient power management =
in mobile
>>> devices, including enabling efficient transitions between the activ=
e and power
>>> save modes. Combined with a low active power level and a near-zero =
idle power
>>> level, UFS offers the promise for significant reductions in device =
power
>>> consumption.
>>>
>>> The UFS standard adopts the well-known SCSI Architecture Model and =
command
>>> protocols supporting multiple commands with command queuing feature=
s and
>>> enabling a multi-thread programming paradigm. This differs from con=
ventional
>>> flash-based memory cards and embedded flash solutions which process=
 one
>>> command at a time, limiting random read/write access performance.
>>> In addition, a forthcoming complementary UFS Host Controller Interf=
ace (HCI)
>>> specification will allow system designers greater flexibility by si=
mplifying
>>> the involvement of the host processor in the operation of the flash=
 storage
>>> subsystem. The UFS HCI specification and the adoption of SCSI will =
provide
>>> a well-known software programming model and enable wider market ado=
ption.
>>>
>>> This patchset contains PCIe based UFS host controller driver which =
complies
>>> to UFSHCI 1.0 and 1.1. The driver is based on Linux SCSI framework.
>>> The driver is tested with UFS Host controller(FPGA) and UFS device(=
=46PGA).
>>>
>>> This patch set is successfully applied on kernel version 3.3-rc2.
>>>
>>> Santosh Yaraganavi (4):
>>> =A0[SCSI] ufshcd: UFS Host controller driver
>>> =A0[SCSI] ufshcd: UFS UTP Transfer requests handling
>>> =A0[SCSI] ufshcd: UFSHCI error handling
>>> =A0[SCSI] ufshcd: SCSI error handling
>>>
>>> =A0drivers/scsi/Kconfig =A0 =A0 =A0| =A0 =A01 +
>>> =A0drivers/scsi/Makefile =A0 =A0 | =A0 =A01 +
>>> =A0drivers/scsi/ufs/Kconfig =A0| =A0 49 ++
>>> =A0drivers/scsi/ufs/Makefile | =A0 =A02 +
>>> =A0drivers/scsi/ufs/ufs.h =A0 =A0| =A0203 +++++
>>> =A0drivers/scsi/ufs/ufshcd.c | 1954 +++++++++++++++++++++++++++++++=
++++++++++++++
>>> =A0drivers/scsi/ufs/ufshci.h | =A0360 +++++++++
>>> =A07 files changed, 2570 insertions(+), 0 deletions(-)
>>> =A0create mode 100644 drivers/scsi/ufs/Kconfig
>>> =A0create mode 100644 drivers/scsi/ufs/Makefile
>>> =A0create mode 100644 drivers/scsi/ufs/ufs.h
>>> =A0create mode 100644 drivers/scsi/ufs/ufshcd.c
>>> =A0create mode 100644 drivers/scsi/ufs/ufshci.h
>>>
>>> --
>>> 1.7.5.4
>> Hi.
>> I have been waiting for ufs contribution.
>> Unfortunately I don't have real target supported ufs(maybe only you
>> have it). I can not debug and run this code, So just review only cod=
e
>> with specification.
>>>
> Hi. Santosh.
> Would you share performance measurement result (read/write seq,ran) ?
> Thanks.

Hi Namjae,

Currently UFS Driver is being tested on on UFS Controller FPGA and UFS
Device FPGA. So currently the main concentration is on functionality.
Performance on FPGA will not be the correct measurement.

>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ker=
nel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>> Please read the FAQ at =A0http://www.tux.org/lkml/

--=20
~Santosh
