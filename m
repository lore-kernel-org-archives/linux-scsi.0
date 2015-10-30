From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v9 8/8] scsi: ufs-qcom: add QUniPro hardware support and
 power optimizations
Date: Fri, 30 Oct 2015 09:32:40 +0100
Message-ID: <56332B28.8070804@suse.de>
References: <1446030951-2431-1-git-send-email-ygardi@codeaurora.org>
 <1446030951-2431-9-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446030951-2431-9-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

On 10/28/2015 12:15 PM, Yaniv Gardi wrote:
> New revisions of UFS host controller supports the new UniPro
> hardware controller (referred as QUniPro). This patch adds
> the support to enable this new UniPro controller hardware.
>=20
> This change also adds power optimization for bus scaling feature,
> as well as support for HS-G3 power mode.
>=20
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
