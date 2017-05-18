From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
Date: Thu, 18 May 2017 15:52:23 +0000
Message-ID: <1495122743.2511.5.camel@sandisk.com>
References: <MWHPR03MB31361482F0BAE79275957D63CEE10@MWHPR03MB3136.namprd03.prod.outlook.com>
         <1494892845.2567.14.camel@sandisk.com>
         <MWHPR03MB3136DEB8FD09EDDF7CDB8BF5CEE60@MWHPR03MB3136.namprd03.prod.outlook.com>
         <1495062317.2679.1.camel@sandisk.com>
         <20170518065454.GA25180@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170518065454.GA25180@infradead.org>
Content-Language: en-US
Content-ID: <07B829C12D29E14FBCFD90C10141DD53@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "sthemmin@microsoft.com" <sthemmin@microsoft.com>, "kys@microsoft.com" <kys@microsoft.com>, "longli@microsoft.com" <longli@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-05-17 at 23:54 -0700, Christoph Hellwig wrote:
> On Wed, May 17, 2017 at 11:05:18PM +0000, Bart Van Assche wrote:
> > Thank you for the feedback. I'm working on a patch series that merges t=
he scsi-sq
> > and scsi-mq code paths for command initialization and that should fix t=
he bug you
> > encountered.
>=20
> While that sounds great (I tried it a while ago but gave up due to
> priorities) I think we should merge this patch as-is and backport it
> to stable for now and rebase your series on top of it.

Hello Christoph,

I will rebase my patch series on top of Long Li's patch. Long, please
repost your patch with a more detailed description and with the Reviewed-by
and Cc: stable tags added.

Thanks,

Bart.=
