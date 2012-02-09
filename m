From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 0/4] [SCSI] ufshcd: UFS Host Controller Driver
Date: Thu, 9 Feb 2012 13:23:42 +0530
Message-ID: <CALMYJDuxaUKkQaU0aHp+omnVy+Vs5y9ZL=LhkgVwhF8POP=d6g@mail.gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
 <CAKYAXd_sRKCfw_rNrRD8yKKQEP_8Zee+E5rZW0G1NuuCA4HcNA@mail.gmail.com>
 <CAKYAXd_msUdB2UbMvxqn751nuN5R=T6W5sjLDMxqEOR6KTX38w@mail.gmail.com>
 <CALMYJDvy58ohVSjeQC2e=rccyKe2S=628q9YBFtpAm7v1HHO3Q@mail.gmail.com> <CAKYAXd83xkxyPNYJf-fBf+oZ8h3GTuRd_8POe6m61t6_AW-mQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <CAKYAXd83xkxyPNYJf-fBf+oZ8h3GTuRd_8POe6m61t6_AW-mQg@mail.gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, arnd@arndb.de, venkat@linaro.org, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 9, 2012 at 10:04 AM, Namjae Jeon <linkinjeon@gmail.com> wro=
te:
> 2012/2/6 Santosh Y <santoshsy@gmail.com>:
>> On Mon, Feb 6, 2012 at 4:15 AM, Namjae Jeon <linkinjeon@gmail.com> w=
rote:
>>> 2012/2/5 Namjae Jeon <linkinjeon@gmail.com>:
>>>> 2012/2/2 Vinayak Holikatti <vinholikatti@gmail.com>:
>>>>> From: Santosh Yaraganavi <santoshsy@gmail.com>
>>>>>
>>>>> UFS is designed to be the most advanced specification for
>>>>> both embedded and removable flash memory-based storage in mobile =
devices
>>>>> such as smart phones and tablet computers. =A0The UFS standard re=
presents
>>>>> an evolutionary progression of JEDEC standards in this field, and=
 has been
>>>>> specifically tailored for mobile applications and computing syste=
ms requiring
>>>>> high performance and low power consumption. =A0The initial data t=
hroughput for
>>>>> UFS will be ~300 megabytes per second (MB/s), and the standard al=
so supports
>>>>> command queuing features to raise random read/write speeds.
>>>>>
>>>>> To achieve the highest performance and most power efficient data
>>>>> transport, UFS uses the leading industry interface standards to f=
orm its
>>>>> Interconnect Layer: MIPI=AE Alliance=92s M-PHY and UniProSM =A0sp=
ecifications.
>>>>> UniPro is a comprehensive specification meant to act as a univers=
al
>>>>> chip-to-chip protocol, providing a common tunnel for other protoc=
ols.
>>>>> The M-PHY interface is designed as the primary physical interface=
 (PHY layer)
>>>>> for the UniPro specification, and is a high speed serial interfac=
e targeting
>>>>> up to 2.9 gigabits per second (Gbps) per lane with up-scalability=
 to 5.8Gbps
>>>>> per lane.
>>>>>
>>>>> MIPI=92s M-PHY and UniPro specifications are optimized for mobile=
 applications,
>>>>> and are designed from the ground up for efficient power managemen=
t in mobile
>>>>> devices, including enabling efficient transitions between the act=
ive and power
>>>>> save modes. Combined with a low active power level and a near-zer=
o idle power
>>>>> level, UFS offers the promise for significant reductions in devic=
e power
>>>>> consumption.
>>>>>
>>>>> The UFS standard adopts the well-known SCSI Architecture Model an=
d command
>>>>> protocols supporting multiple commands with command queuing featu=
res and
>>>>> enabling a multi-thread programming paradigm. This differs from c=
onventional
>>>>> flash-based memory cards and embedded flash solutions which proce=
ss one
>>>>> command at a time, limiting random read/write access performance.
>>>>> In addition, a forthcoming complementary UFS Host Controller Inte=
rface (HCI)
>>>>> specification will allow system designers greater flexibility by =
simplifying
>>>>> the involvement of the host processor in the operation of the fla=
sh storage
>>>>> subsystem. The UFS HCI specification and the adoption of SCSI wil=
l provide
>>>>> a well-known software programming model and enable wider market a=
doption.
>>>>>
>>>>> This patchset contains PCIe based UFS host controller driver whic=
h complies
>>>>> to UFSHCI 1.0 and 1.1. The driver is based on Linux SCSI framewor=
k.
>>>>> The driver is tested with UFS Host controller(FPGA) and UFS devic=
e(FPGA).
>>>>>
>>>>> This patch set is successfully applied on kernel version 3.3-rc2.
>>>>>
>>>>> Santosh Yaraganavi (4):
>>>>> =A0[SCSI] ufshcd: UFS Host controller driver
>>>>> =A0[SCSI] ufshcd: UFS UTP Transfer requests handling
>>>>> =A0[SCSI] ufshcd: UFSHCI error handling
>>>>> =A0[SCSI] ufshcd: SCSI error handling
>>>>>
>>>>> =A0drivers/scsi/Kconfig =A0 =A0 =A0| =A0 =A01 +
>>>>> =A0drivers/scsi/Makefile =A0 =A0 | =A0 =A01 +
>>>>> =A0drivers/scsi/ufs/Kconfig =A0| =A0 49 ++
>>>>> =A0drivers/scsi/ufs/Makefile | =A0 =A02 +
>>>>> =A0drivers/scsi/ufs/ufs.h =A0 =A0| =A0203 +++++
>>>>> =A0drivers/scsi/ufs/ufshcd.c | 1954 +++++++++++++++++++++++++++++=
++++++++++++++++
>>>>> =A0drivers/scsi/ufs/ufshci.h | =A0360 +++++++++
>>>>> =A07 files changed, 2570 insertions(+), 0 deletions(-)
>>>>> =A0create mode 100644 drivers/scsi/ufs/Kconfig
>>>>> =A0create mode 100644 drivers/scsi/ufs/Makefile
>>>>> =A0create mode 100644 drivers/scsi/ufs/ufs.h
>>>>> =A0create mode 100644 drivers/scsi/ufs/ufshcd.c
>>>>> =A0create mode 100644 drivers/scsi/ufs/ufshci.h
>>>>>
>>>>> --
>>>>> 1.7.5.4
>>>> Hi.
>>>> I have been waiting for ufs contribution.
>>>> Unfortunately I don't have real target supported ufs(maybe only yo=
u
>>>> have it). I can not debug and run this code, So just review only c=
ode
>>>> with specification.
>>>>>
>>> Hi. Santosh.
>>> Would you share performance measurement result (read/write seq,ran)=
 ?
>>> Thanks.
>>
>> Hi Namjae,
>>
>> Currently UFS Driver is being tested on on UFS Controller FPGA and U=
=46S
>> Device FPGA. So currently the main concentration is on functionality=
=2E
>> Performance on FPGA will not be the correct measurement.
> Hi. Santosh.
> If possible, I hope that you share performance to us when you post ne=
w
> patch next time.
> And Personally I am expecting good random I/O speed on UFS.
> Thanks.

Hi Namjae,
As soon as the hardware is available, we'll share the performance resul=
ts.

>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-k=
ernel" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>>>>> Please read the FAQ at =A0http://www.tux.org/lkml/
>>
>> --
>> ~Santosh



--=20
~Santosh
