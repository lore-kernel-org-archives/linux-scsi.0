From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v9 6/8] scsi: ufs: make the UFS variant a platform device
Date: Fri, 30 Oct 2015 09:30:52 +0100
Message-ID: <56332ABC.9060400@suse.de>
References: <1446030951-2431-1-git-send-email-ygardi@codeaurora.org>
 <1446030951-2431-7-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446030951-2431-7-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 10/28/2015 12:15 PM, Yaniv Gardi wrote:
> This change turns the UFS variant (SCSI_UFS_QCOM) into a UFS
> a platform device.
> In order to do so a few additional changes are required:
> 1. The ufshcd-pltfrm is no longer serves as a platform device.
>    Now it only serves as a group of platform APIs such as PM APIs
>    (runtime suspend/resume, system suspend/resume etc), parsers of
>    clocks, regulators and pm_levels from DT.
> 2. What used to be the old platform "probe" is now "only"
>    a pltfrm_init() routine, that does exactly the same, but only
>    being called by the new probe function of the UFS variant.
>=20
> Reviewed-by: Rob Herring <robherring2@gmail.com>
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
