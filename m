From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH RESEND] scsi: sim710: fix build warning
Date: Thu, 11 Feb 2016 09:46:11 +0100
Message-ID: <20160211084611.GW27969@c203.arch.suse.de>
References: <1455166743-3572-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455166743-3572-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 11, 2016 at 10:29:03AM +0530, Sudip Mukherjee wrote:
> We are getting build warning about:
>  "Section mismatch in reference from the variable sim710_eisa_driver =
to
>  the function .init.text:sim710_eisa_probe()
>  The variable sim710_eisa_driver references the function __init
>  sim710_eisa_probe()"
>=20
> sim710_eisa_probe() was having __init but that was being referenced f=
rom
> sim710_eisa_driver.
>=20
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
