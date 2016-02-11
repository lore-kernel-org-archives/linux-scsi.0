From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 2/7] ibmvscsi: Add and use enums for valid CRQ header
 values
Date: Thu, 11 Feb 2016 09:51:46 +0100
Message-ID: <20160211085146.GX27969@c203.arch.suse.de>
References: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <1455154348-3226-3-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455154348-3226-3-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 10, 2016 at 07:32:23PM -0600, Tyrel Datwyler wrote:
> The PAPR defines four valid header values for the first byte of a
> CRQ message. Namely, an unused/empty message (0x00), a valid
> command/response entry (0x80), a valid initialization entry (0xC0),
> and a valid transport event (0xFF). Further, initialization responses
> have two formats namely initialize (0x01) and initialize complete
> (0x02). Define these values as enums and use them in the code in
> place of their magic number equivalents.
>=20
> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
