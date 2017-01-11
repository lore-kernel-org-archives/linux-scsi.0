From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH] scsi: qedi: select UIO
Date: Wed, 11 Jan 2017 09:00:54 +0000
Message-ID: <D49BF0E9.3633C%manish.rangankar@cavium.com>
References: <20170110152744.3139180-1-arnd@arndb.de>
 <1484079574.15161.91.camel@localhost.localdomain>
 <yq137gqs0cd.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq137gqs0cd.fsf@oracle.com>
Content-Language: en-US
Content-ID: <59E670F8074C244CB20BC125B7D3865D@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "Ewan D. Milne" <emilne@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Javali, Nilesh" <Nilesh.Javali@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 11/01/17 9:40 AM, "Martin K. Petersen" <martin.petersen@oracle.com>
wrote:

>>>>>> "Ewan" =3D=3D Ewan D Milne <emilne@redhat.com> writes:
>
>Ewan> Randy posted a similar patch back in December but I don't think
>Ewan> there was ever a reply to Christoph's question about why qedi
>Ewan> depends on uio.
>
>I did queue up Randy's patch to shut up the build warnings. But we're
>still looking for a long term fix or an explanation as to why UIO is
>needed in the first place.

Similar to bnx2i driver, qedi driver also has a dependency over iscsiuio
to provide ARP and DHCP functionality for iscsi offload, and the
communication to the
driver is done via uio interface.

https://github.com/open-iscsi/open-iscsi/blob/master/iscsiuio/README


Thanks,
Manish
