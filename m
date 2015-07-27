From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3] [SCSI] mpt2sas, mpt3sas: Abort initialization if no
 memory I/O resources detected
Date: Mon, 27 Jul 2015 10:19:24 +0200
Message-ID: <55B5E98C.5080106@suse.de>
References: <1436935796-28995-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436935796-28995-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, tpearson@raptorengineeringinc.com, jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On 07/15/2015 06:49 AM, Sreekanth Reddy wrote:
> Driver crashes if the BIOS do not set up at least one
> memory I/O resource. This failure can happen if the device is too
> slow to respond during POST and is missed by the BIOS, but Linux
> then detects the device later in the boot process.
>=20
> Changes in v3:
>    Rearranged the code to remove the code redundancy
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
