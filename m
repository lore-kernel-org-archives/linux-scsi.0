From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
Date: Tue, 16 May 2017 00:00:46 +0000
Message-ID: <1494892845.2567.14.camel@sandisk.com>
References: <MWHPR03MB31361482F0BAE79275957D63CEE10@MWHPR03MB3136.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR03MB31361482F0BAE79275957D63CEE10@MWHPR03MB3136.namprd03.prod.outlook.com>
Content-Language: en-US
Content-ID: <AFE142C906A8F74AAB7B66FEE876410B@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "longli@microsoft.com" <longli@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "sthemmin@microsoft.com" <sthemmin@microsoft.com>, "kys@microsoft.com" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-05-15 at 23:32 +0000, Long Li wrote:
> Thanks for looking! Yes this is for chasing a bug.=20
>=20
> With the patch, we also zero the private data used by lower layer driver,=
 in
> addition to the private data in scsi_cmnd.

Hello Long,

What bug did you encounter, with which combination of ULP (sd?) and LLD SCS=
I
driver(s) and for which request type (REQ_OP_*)? You will have to mention t=
hat
information in the patch description anyway if you want your patch to get
accepted.

If the bug that you encountered only occurs with a single LLD, would it be
possible to implement a fix by modifying the LLD instead of the SCSI core?

Thanks,

Bart.=
