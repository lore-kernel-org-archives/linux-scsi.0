From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
Date: Thu, 18 May 2017 13:29:19 +0000
Message-ID: <BN6PR03MB248142AAC3E0D9851D2A841DA0E40@BN6PR03MB2481.namprd03.prod.outlook.com>
References: <MWHPR03MB31361482F0BAE79275957D63CEE10@MWHPR03MB3136.namprd03.prod.outlook.com>
 <1494892845.2567.14.camel@sandisk.com>
 <MWHPR03MB3136DEB8FD09EDDF7CDB8BF5CEE60@MWHPR03MB3136.namprd03.prod.outlook.com>
 <1495062317.2679.1.camel@sandisk.com> <20170518065454.GA25180@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170518065454.GA25180@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Long Li <longli@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Stephen Hemminger <sthemmin@microsoft.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, May 17, 2017 11:55 PM
> To: Bart Van Assche <Bart.VanAssche@sandisk.com>
> Cc: jejb@linux.vnet.ibm.com; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; Long Li <longli@microsoft.com>;
> martin.petersen@oracle.com; Stephen Hemminger
> <sthemmin@microsoft.com>; KY Srinivasan <kys@microsoft.com>
> Subject: Re: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
>=20
> On Wed, May 17, 2017 at 11:05:18PM +0000, Bart Van Assche wrote:
> > Thank you for the feedback. I'm working on a patch series that merges t=
he
> scsi-sq
> > and scsi-mq code paths for command initialization and that should fix t=
he
> bug you
> > encountered.
>=20
> While that sounds great (I tried it a while ago but gave up due to
> priorities) I think we should merge this patch as-is and backport it
> to stable for now and rebase your series on top of it.
Thanks Christoph.

K. Y
