From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [LFS/MM TOPIC][LFS/MM ATTEND]: - Storage Stack and Driver
 Testing methodology.
Date: Fri, 10 Mar 2017 19:37:58 +0000
Message-ID: <1489174661.2548.5.camel@sandisk.com>
References: <CO2PR04MB218427BF42159B20FB26F74186670@CO2PR04MB2184.namprd04.prod.outlook.com>
         <CO2PR04MB2184DB653C04FB620B41435486670@CO2PR04MB2184.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CO2PR04MB2184DB653C04FB620B41435486670@CO2PR04MB2184.namprd04.prod.outlook.com>
Content-Language: en-US
Content-ID: <2DADA320DF156E4BB34336358E8539A8@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-01-10 at 22:40 +0000, Chaitanya Kulkarni wrote:
> Participants:-
> ------------------
> I'd like to invite developers from different subsystems to discuss an app=
roach towards=A0
> a unified testing methodology for storage stack and device drivers belong=
s to=A0
> different subsystems.
>=20
> Topics for Discussion:-
> ------------------------------
> As a part of discussion following are some of the key points which we can=
 focus on:-
> 1. What are the common components of the kernel used by the various subsy=
stems?
> 2. What are the potential target drivers which can benefit from this appr=
oach?=A0
> =A0 (e.g. NVMe, NVMe Over Fabric, Open Channel Solid State Drives etc.)
> 3. What are the desired features that can be implemented in this Framewor=
k?
> =A0 (code coverage, unit tests, stress testings, regression, generating C=
occinelle reports etc.)=A0
> 4. Desirable Report generation mechanism?
> 5. Basic performance validation?
> 6. Whether QEMU can be used to emulate some of the H/W functionality to c=
reate a test=A0
> =A0 platform? (Optional subsystem specific)

Regarding existing test software: the SRP test software is a thorough test =
of
the Linux block layer, SCSI core, dm-mpath driver, dm core, SRP initiator a=
nd
target drivers and also of the asynchronous I/O subsystem. This test suite
includes experimental support for the NVMeOF drivers. This test suite suppo=
rts
the rdma_rxe driver which means that an Ethernet adapter is sufficient to r=
un
these tests.

Note: the focus of this test suite is the regular I/O path and device remov=
al.
This test suite neither replaces the libiscsi tests nor xfstests.

See also https://github.com/bvanassche/srp-test.

Bart.=
