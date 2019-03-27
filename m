From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH RESEND v3 0/5] scsi: ufs: Fix regulator operations and
 remove "<name>-fixed-regulator" device tree property
Date: Wed, 27 Mar 2019 21:24:37 +0800
Message-ID: <1553693077.30977.94.camel@mtkswgap22>
References: <1553680707-28579-1-git-send-email-stanley.chu@mediatek.com>
 <SN6PR04MB49250E97111EB8975E0ED7EFFC580@SN6PR04MB4925.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <SN6PR04MB49250E97111EB8975E0ED7EFFC580-UKdxhu0+N/VnT3GYGerMaFM8qxBPnqtHvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Avri Altman <Avri.Altman-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "marc.w.gonzalez-GANU6spQydw@public.gmane.org" <marc.w.gonzalez-GANU6spQydw@public.gmane.org>, "chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org" <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, "matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org" <pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Avri,

On Wed, 2019-03-27 at 10:57 +0000, Avri Altman wrote:
> > Hi,
> > 
> > Resend this patch series for review.
> > 
> > This version (v3) fixed and added more details in commit messages, and added
> > one patch to fix "undefined voltage range" issue as well.
> > 
> > This patch series fixes UFS regulator operations, including voltage and current
> > (re-)configuration flow during UFS initialization and power mode switching.
> > 
> > In the end, remove "<name>-fixed-regulator" device tree property because it is
> > not necessary anymore after these fixes.
> > 
> > V3:
> > - Fix and add more details in commit messages.
> > - Add one patch "scsi: ufs: Avoid configuring undefined voltage range on a
> > regulator".
> > 
> > V2:
> > - Add two patches to prepare to and remove "<name>-fixed-regulator" device
> > tree property.
> > - Add more details on patch "scsi: ufs: remove unused min_uA field in struct
> > ufs_vreg" (Marc Gonzalez).
> > 
> > Stanley Chu (5):
> >   scsi: ufs: Remove unused min_uA field in struct ufs_vreg
> >   scsi: ufs: Avoid configuring regulator with undefined voltage range
> >   scsi: ufs: Fix regulator load and icc-level configuration
> >   scsi: ufs: Change "<name>-max-microamp" to non-mandatory property
> >   scsi: ufs: Remove "<name>-fixed-regulator" device tree property
> > 
> This series looks good to me, but better get acked-by from couple of platform guys as well.

Thanks so much for review.

I'll fix commit message and invite more reviewers in next version.

> 
> Thanks,
> Avri
> 

Thanks,
Stanley
