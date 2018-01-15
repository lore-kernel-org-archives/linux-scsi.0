From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: A qla2xxx commit cause Linux no response, has not fixed in
 lastest version 4.15-rc6
Date: Mon, 15 Jan 2018 16:57:47 +0000
Message-ID: <74BFA730-FDBB-4912-B4E3-734A84C6A63A@cavium.com>
References: <BC29A004BA570342A4CC0044A3845572010DCF3E30@H3CMLB12-EX.srv.huawei-3com.com>
 <1515821296.24576.94.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1515821296.24576.94.camel@haakon3.daterainc.com>
Content-Language: en-US
Content-ID: <A865ED20B3EFDB4B9959CA6C5E9BEEB3@namprd07.prod.outlook.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Changlimin <changlimin@h3c.com>, "Tran, Quinn" <Quinn.Tran@cavium.com>, Jifuliang <fuliang_ji@h3c.com>, Zhangguanghui <zhang.guanghui@h3c.com>, Zhangzijian <zhang.zijian@h3c.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Nic, Chang,

> On Jan 12, 2018, at 9:28 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> =
wrote:
>=20
> Hi Chang & Co,
>=20
> (Adding list + Himanshu CC')
>=20
> On Sun, 2018-01-07 at 10:21 +0000, Changlimin wrote:
>> Hi,
>> It seems the qla2xxx commit cause Linux no response, has not fixed in la=
stest version 4.15-rc6.
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/=
commit/?id=3D726b85487067d7f5b23495bc33c484b8517c4074=20
>>=20
>=20
> Thanks for reporting + including debug log.  :)
>=20
>> lspci:
>> 0a:00.0 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to P=
CI Express HBA (rev 02)
>> 0a:00.1 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to P=
CI Express HBA (rev 02)
>>=20
>> syslog:
>> qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.=
38-k.
>> qla2xxx [0000:0a:00.0]-001a: : MSI-X vector count: 32.
>> qla2xxx [0000:0a:00.0]-001d: : Found an ISP2532 irq 16 iobase 0xffffb0d5=
cc501000.
>> qla2xxx [0000:0a:00.0]-00c6:1: MSI-X: Failed to enable support with 32 v=
ectors, using 26 vectors.
>> scsi host1: qla2xxx
>> qla2xxx [0000:0a:00.0]-00fb:1: QLogic HPAJ764A - HP 8Gb Dual Channel PCI=
-e 2.0 FC HBA.
>> qla2xxx [0000:0a:00.0]-00fc:1: ISP2532: PCIe (5.0GT/s x8) @ 0000:0a:00.0=
 hdma+ host#=3D1 fw=3D8.03.00 (90d5).
>> qla2xxx [0000:0a:00.1]-001a: : MSI-X vector count: 32.
>> qla2xxx [0000:0a:00.1]-001d: : Found an ISP2532 irq 17 iobase 0xffffb0d5=
cc5d9000.
>> qla2xxx [0000:0a:00.1]-00c6:2: MSI-X: Failed to enable support with 32 v=
ectors, using 26 vectors.
>> scsi host2: qla2xxx
>> qla2xxx [0000:0a:00.1]-00fb:2: QLogic HPAJ764A - HP 8Gb Dual Channel PCI=
-e 2.0 FC HBA.
>> qla2xxx [0000:0a:00.1]-00fc:2: ISP2532: PCIe (5.0GT/s x8) @ 0000:0a:00.1=
 hdma+ host#=3D2 fw=3D8.03.00 (90d5).
>> qla2xxx [0000:0a:00.0]-500a:1: LOOP UP detected (8 Gbps).
>> qla2xxx [0000:0a:00.1]-500a:2: LOOP UP detected (8 Gbps).
>>=20
>> The attached file is the module log.
>>=20
>> Do you have any advice?
>=20
> Quinn & Himanshu folks, any comments..?
>=20

What is the issue here? I am not clear form the snippet above.

One thing I noticed that, if you are using 4.15-rc6 driver version should b=
e 10.00.00.02-k but the snippet shows=20
8.07.00.38-k which tells me you might=20

Thanks,
- Himanshu=
