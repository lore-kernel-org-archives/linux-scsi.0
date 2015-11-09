From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA
 fails
Date: Mon, 09 Nov 2015 08:09:39 +0100
Message-ID: <564046B3.8090505@suse.de>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org> <1447034266-28003-2-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1447034266-28003-2-git-send-email-okaya@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>, linux-scsi@vger.kernel.org, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com
Cc: agross@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, MPT-FusionLinux.pdl@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/09/2015 02:57 AM, Sinan Kaya wrote:
> Current code gives up when 32 bit DMA is not supported.
> This problem has been observed on systems without any
> memory below 4 gig.
>=20
> This patch tests 64 bit support before bailing out to find
> a working combination.
>=20
That feels decidedly odd.

Why do you probe for 64bit if 32bit fails?
Typically it's the other way round, on the grounds that 64bit DMA
should be preferred over 32bit.
Can you explain why it needs to be done the other way round here?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
