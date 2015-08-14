From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Export SCSI Inquiry data to sysfs
Date: Fri, 14 Aug 2015 08:32:04 +0200
Message-ID: <55CD8B64.1080400@suse.de>
References: <1439466608-31577-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439466608-31577-1-git-send-email-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/13/2015 01:50 PM, Johannes Thumshirn wrote:
> Export the RAW SCSI Inquiry to sysfs as binfile. This way the data ca=
n be
> used by userlang without the need to have and ioctl or use the sg_inq=
 tool.
>=20
userland!

> Here is an example of the provided data
>=20
> linux:~ # hexdump /sys/class/scsi_device/1\:0\:0\:0/device/inquiry
> 0000000 8005 3205 001f 0000 4551 554d 2020 2020
> 0000010 4551 554d 4420 4456 522d 4d4f 2020 2020
> 0000020 2e32 2e33
> 0000024
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi_sysfs.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
