From: "Gurumurthy, Anil" <Anil.Gurumurthy@cavium.com>
Subject: RE: [PATCH 0/7] scsi: bfa: do_gettimeofday removal
Date: Fri, 10 Nov 2017 17:33:29 +0000
Message-ID: <BLUPR0701MB20180115310620C5EB68A7008E540@BLUPR0701MB2018.namprd07.prod.outlook.com>
References: <20171110153715.1929456-1-arnd@arndb.de>
 <20171110172435.GB15288@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171110172435.GB15288@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Cc: "Kalluru, Sudarsana" <Sudarsana.Kalluru@cavium.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "y2038@lists.linaro.org" <y2038@lists.linaro.org>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

The bfa drivers are in deep maintenance mode for some time now. We have not=
 had issues reported on them for a while, but it would be good to continue =
to have them.

The series looks ok to me too.

Thanks,
Anil

-----Original Message-----
From: Christoph Hellwig [mailto:hch@lst.de]=20
Sent: 10 November 2017 22:55
To: Arnd Bergmann <arnd@arndb.de>
Cc: Gurumurthy, Anil <Anil.Gurumurthy@cavium.com>; Kalluru, Sudarsana <Suda=
rsana.Kalluru@cavium.com>; James E . J . Bottomley <jejb@linux.vnet.ibm.com=
>; Martin K . Petersen <martin.petersen@oracle.com>; linux-scsi@vger.kernel=
.org; linux-kernel@vger.kernel.org; y2038@lists.linaro.org; hch@lst.de; har=
e@suse.com; jthumshirn@suse.de
Subject: Re: [PATCH 0/7] scsi: bfa: do_gettimeofday removal

This stuff look ok - but I have a bigger question and that is if bfa is sti=
ll alive at all.  Everytime I look at it I have doubts if it works at all, =
so I wonder if we need to keep it on life support.
