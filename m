From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 07/15] scsi: ufs: set REQUEST_SENSE command size to 18
 bytes
Date: Fri, 30 Oct 2015 13:16:49 +0100
Message-ID: <56335FB1.3050301@suse.de>
References: <1446038045-17102-1-git-send-email-ygardi@codeaurora.org>
 <1446038045-17102-8-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1446038045-17102-8-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

On 10/28/2015 02:13 PM, Yaniv Gardi wrote:
> According to UFS device specification REQUEST_SENSE command can
> only report back up to 18 bytes of data.
>=20
> Reviewed-by: Dolev Raviv <draviv@codeaurora.org>
> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>=20
Really? The spec only says that the inline sense code is 18 bytes;
if you issue a request sense directly there is not such limitation.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
