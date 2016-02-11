From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 5/7] ibmvscsi: Remove unsupported host config MAD
Date: Thu, 11 Feb 2016 09:53:29 +0100
Message-ID: <20160211085329.GY27969@c203.arch.suse.de>
References: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <1455154348-3226-6-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455154348-3226-6-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 10, 2016 at 07:32:26PM -0600, Tyrel Datwyler wrote:
> A VIOSRP_HOST_CONFIG_TYPE management datagram (MAD) has existed in
> the code for some time. From what information I've gathered from
> Brian King this was likely implemented on the host side in a SLES 9
> based VIOS, which is no longer supported anywhere. Further, it is
> not defined in PAPR or supported by any AIX based VIOS.
>=20
> Treating as bit rot and removing the associated host config code.
> The config attribute and its show function are left as not to break
> userspace. The behavior remains the same returning nothing.
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
