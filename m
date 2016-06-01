From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/5] scsi: Use pci_(request|release)_mem_regions
Date: Wed, 1 Jun 2016 10:04:31 +0200
Message-ID: <20160601080431.3sgbeapns2sh6zmh@c203.arch.suse.de>
References: <cover.1464694724.git.jthumshirn@suse.de>
 <1123377cf09b08091957c7d1f58be1601dbfb50c.1464694724.git.jthumshirn@suse.de>
 <20160601075929.GC11923@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160601075929.GC11923@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 01, 2016 at 12:59:29AM -0700, Christoph Hellwig wrote:
> On Tue, May 31, 2016 at 02:05:11PM +0200, Johannes Thumshirn wrote:
> > Now that we do have pci_request_mem_regions() and pci_release_mem_r=
egions() at
> > hand, use it in the lpfc driver.
>=20
> This should read lpfc instead of scsi in the subject line.
>=20
> Also the request side of the patch seems to be missing.

You're right. I'll be checking why the coccinelle spatch didn't catch i=
t up.

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
