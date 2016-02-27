From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 3/6] hisi_sas: use slot abort in v1 hw
Date: Sat, 27 Feb 2016 19:58:31 +0800
Message-ID: <56D18F67.4080707@suse.de>
References: <1456393335-38294-1-git-send-email-john.garry@huawei.com>
 <1456393335-38294-4-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456393335-38294-4-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/25/2016 05:42 PM, John Garry wrote:
> When TRANS_TX_CREDIT_TIMEOUT_ERR or
> TRANS_TX_CLOSE_NORMAL_ERR error occur in
> a slot, the command should be re-attempted.
> This error is equivalent to meaning that the queue
> is full in the sdev (and not the host).
>=20
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
