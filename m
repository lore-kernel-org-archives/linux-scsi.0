From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [LFS/MM TOPIC][LFS/MM ATTEND]: - Storage Stack and Driver Testing
 methodology.
Date: Tue, 10 Jan 2017 22:40:53 +0000
Message-ID: <CO2PR04MB2184DB653C04FB620B41435486670@CO2PR04MB2184.namprd04.prod.outlook.com>
References: <CO2PR04MB218427BF42159B20FB26F74186670@CO2PR04MB2184.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CO2PR04MB218427BF42159B20FB26F74186670@CO2PR04MB2184.namprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Resending it at as a plain text.

From: Chaitanya Kulkarni
Sent: Tuesday, January 10, 2017 2:37 PM
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org; linux-block@vger.kernel.org; linux-nvme@=
lists.infradead.org; linux-scsi@vger.kernel.org; linux-ide@vger.kernel.org
Subject: [LFS/MM TOPIC][LFS/MM ATTEND]: - Storage Stack and Driver Testing =
methodology.
=A0=20

Hi Folks,

I would like to propose a general discussion on Storage stack and device dr=
iver testing.

Purpose:-
-------------
The main objective of this discussion is to address the need for=A0
a Unified Test Automation Framework which can be used by different subsyste=
ms
in the kernel in order to improve the overall development and stability
of the storage stack.

For Example:-=A0
>From my previous experience, I've worked on the NVMe driver testing last ye=
ar and we
have developed simple unit test framework
=A0(https://github.com/linux-nvme/nvme-cli/tree/master/tests).=A0
In current implementation Upstream NVMe Driver supports following subsystem=
s:-
1. PCI Host.
2. RDMA Target.
3. Fiber Channel Target (in progress).
Today due to lack of centralized automated test framework NVMe Driver testi=
ng is=A0
scattered and performed using the combination of various utilities like nvm=
e-cli/tests,=A0
nvmet-cli, shell scripts (git://git.infradead.org/nvme-fabrics.git nvmf-sel=
ftests) etc.

In order to improve overall driver stability with various subsystems, it wi=
ll be beneficial
to have a Unified Test Automation Framework (UTAF) which will centralize ov=
erall
testing.=A0

This topic will allow developers from various subsystem engage in the discu=
ssion about=A0
how to collaborate efficiently instead of having discussions on lengthy ema=
il threads.

Participants:-
------------------
I'd like to invite developers from different subsystems to discuss an appro=
ach towards=A0
a unified testing methodology for storage stack and device drivers belongs =
to=A0
different subsystems.

Topics for Discussion:-
------------------------------
As a part of discussion following are some of the key points which we can f=
ocus on:-
1. What are the common components of the kernel used by the various subsyst=
ems?
2. What are the potential target drivers which can benefit from this approa=
ch?=A0
=A0 (e.g. NVMe, NVMe Over Fabric, Open Channel Solid State Drives etc.)
3. What are the desired features that can be implemented in this Framework?
=A0 (code coverage, unit tests, stress testings, regression, generating Coc=
cinelle reports etc.)=A0
4. Desirable Report generation mechanism?
5. Basic performance validation?
6. Whether QEMU can be used to emulate some of the H/W functionality to cre=
ate a test=A0
=A0 platform? (Optional subsystem specific)

Some background about myself I'm Chaitanya Kulkarni, I worked as a team lea=
d=A0
which was responsible for delivering scalable multiplatform Automated Test=
=A0
Framework for device drivers testing at HGST. It's been used for more than =
1 year on=A0
Linux/Windows for unit testing/regression/performance validation of the NVM=
e Linux and
Windows driver successfully. I've also recently started contributing=A0to t=
he=A0

NVMe Host and NVMe over Fabrics Target driver.

Regards,
-Chaitanya

     =
