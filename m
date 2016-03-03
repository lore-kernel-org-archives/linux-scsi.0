From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 08/14] scsi: mvumi: use __maybe_unused to hide pm
 functions
Date: Thu, 3 Mar 2016 09:30:12 +0100
Message-ID: <20160303083012.GE25301@c203.arch.suse.de>
References: <1456934350-1389172-1-git-send-email-arnd@arndb.de>
 <1456934350-1389172-9-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1456934350-1389172-9-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 02, 2016 at 04:59:00PM +0100, Arnd Bergmann wrote:
> The mvumi scsi hides the references to its suspend/resume functions
> in an #ifdef but does not hide the implementation the same way:
>=20
> drivers/scsi/mvumi.c:2632:12: error: 'mvumi_suspend' defined but not =
used [-Werror=3Dunused-function]
> drivers/scsi/mvumi.c:2651:12: error: 'mvumi_resume' defined but not u=
sed [-Werror=3Dunused-function]
>=20
> This adds __maybe_unused annotations so the compiler knows
> it can silently drop them instead of warning, while avoiding
> the addition of another #ifdef.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
