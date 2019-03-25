From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 0/5] scsi: ufs: Fix regulator operations and remove
 "<name>-fixed-regulator" device tree property
Date: Mon, 25 Mar 2019 09:16:20 +0800
Message-ID: <1553476580.30977.91.camel@mtkswgap22>
References: <1552875280-16196-1-git-send-email-stanley.chu@mediatek.com>
 <1552875280-16196-2-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1552875280-16196-2-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, avri.altman-Sjgp3cTcYWE@public.gmane.org, alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org
Cc: "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "marc.w.gonzalez-GANU6spQydw@public.gmane.org" <marc.w.gonzalez-GANU6spQydw@public.gmane.org>, Chun-Hung Wu =?UTF-8?Q?=28=E5=B7=AB=E9=A7=BF=E5=AE=8F=29?= <Chun-hung.Wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Kuohong Wang =?UTF-8?Q?=28=E7=8E=8B=E5=9C=8B=E9=B4=BB=29?= <kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Peter Wang =?UTF-8?Q?=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29?= <peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Avri, Alim, Pedrom,

Gentle ping for this series.

On Mon, 2019-03-18 at 10:14 +0800, Stanley Chu wrote:
> Hi,
> 
> Sorry please help review V3 instead of previous versions.
> In this version I fix and add more details in commit messages, and add one patch to fix "undefined voltage range" issue as well.
> 
> This patch series fixes UFS regulator operations, including voltage and current (re-)configuration flow during initialization or different power modes.
> 
> Besides, remove "<name>-fixed-regulator" device tree property because it is not necessary anymore after fixes.
> 
> V3:
> - Fix and add more details in commit messages.
> - Add one patch "scsi: ufs: Avoid configuring undefined voltage range on a regulator".
> 
> V2:
> - Add two patches to prepare to and remove "<name>-fixed-regulator" device tree property.
> - Add more details on patch "scsi: ufs: remove unused min_uA field in struct ufs_vreg" (Marc Gonzalez).
> 
> Stanley Chu (5):
>   scsi: ufs: Remove unused min_uA field in struct ufs_vreg
>   scsi: ufs: Avoid configuring undefined voltage range on a regulator
>   scsi: ufs: Fix regulator load and icc-level configuration
>   scsi: ufs: Change "<name>-max-microamp" to non-mandatory property
>   scsi: ufs: Remove "<name>-fixed-regulator" device tree property
> 
>  drivers/scsi/ufs/ufs.h           |  1 -
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 14 +++-----------
>  drivers/scsi/ufs/ufshcd.c        | 28 ++++++++++++++++++++--------
>  3 files changed, 23 insertions(+), 20 deletions(-)
> 

Thanks,
Stanley
