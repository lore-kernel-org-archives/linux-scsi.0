From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
Date: Thu, 18 May 2017 16:47:00 +0000
Message-ID: <MWHPR03MB3136E4C180B10B99492272D4CEE40@MWHPR03MB3136.namprd03.prod.outlook.com>
References: <MWHPR03MB31361482F0BAE79275957D63CEE10@MWHPR03MB3136.namprd03.prod.outlook.com>
         <1494892845.2567.14.camel@sandisk.com>
         <MWHPR03MB3136DEB8FD09EDDF7CDB8BF5CEE60@MWHPR03MB3136.namprd03.prod.outlook.com>
         <1495062317.2679.1.camel@sandisk.com>
         <20170518065454.GA25180@infradead.org> <1495122743.2511.5.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0127.outbound.protection.outlook.com ([104.47.34.127]:61792
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932900AbdERQrS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 May 2017 12:47:18 -0400
In-Reply-To: <1495122743.2511.5.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@infradead.org" <hch@infradead.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Hemminger <sthemmin@microsoft.com>, KY Srinivasan <kys@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>



> -----Original Message-----
> From: Bart Van Assche [mailto:Bart.VanAssche@sandisk.com]
> Sent: Thursday, May 18, 2017 8:52 AM
> To: hch@infradead.org
> Cc: jejb@linux.vnet.ibm.com; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; Stephen Hemminger <sthemmin@microsoft.com>; KY
> Srinivasan <kys@microsoft.com>; Long Li <longli@microsoft.com>;
> martin.petersen@oracle.com
> Subject: Re: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
>=20
> On Wed, 2017-05-17 at 23:54 -0700, Christoph Hellwig wrote:
> > On Wed, May 17, 2017 at 11:05:18PM +0000, Bart Van Assche wrote:
> > > Thank you for the feedback. I'm working on a patch series that
> > > merges the scsi-sq and scsi-mq code paths for command initialization
> > > and that should fix the bug you encountered.
> >
> > While that sounds great (I tried it a while ago but gave up due to
> > priorities) I think we should merge this patch as-is and backport it
> > to stable for now and rebase your series on top of it.
>=20
> Hello Christoph,
>=20
> I will rebase my patch series on top of Long Li's patch. Long, please rep=
ost your
> patch with a more detailed description and with the Reviewed-by and Cc:
> stable tags added.

Will do that.

>=20
> Thanks,
>=20
> Bart.
