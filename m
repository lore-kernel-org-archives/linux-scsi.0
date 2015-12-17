From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [RFC PATCH] lpfc: Add lockdep assertions
Date: Thu, 17 Dec 2015 09:49:54 +0100
Message-ID: <20151217084954.GB2890@c203.arch.suse.de>
References: <1448023037-43391-1-git-send-email-jthumshirn@suse.de>
 <5671F24A.1020607@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5671F24A.1020607@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 16, 2015 at 03:22:50PM -0800, James Smart wrote:
> Johannes,
>=20
> Thank you for the time and effort on the patch. At this time, as it d=
oesn't
> functionally change anything, I did not include the patch. I will con=
sider
> it if we see additional issues it can help resolve.

As I already said in the patch mail, I'm not sure if it is of intereset=
 for
upstream, but can actually be quite handy to find something if it goes =
wrong.

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
