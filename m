From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v9 2/8] scsi: ufs-qcom: fix compilation warning if
 compiled as a module
Date: Fri, 30 Oct 2015 09:26:19 +0100
Message-ID: <563329AB.7010400@suse.de>
References: <1446030951-2431-1-git-send-email-ygardi@codeaurora.org>
 <1446030951-2431-3-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446030951-2431-3-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

On 10/28/2015 12:15 PM, Yaniv Gardi wrote:
> This change fixes a compilation warning that happens if SCSI_UFS_QCOM
> is compiled as a module.
> Also this patch fixes an error happens when insmod the module:
> "ufs_qcom: module license 'unspecified' taints kernel."
>=20
> Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
> Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
