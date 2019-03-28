From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RESEND v3 0/5] scsi: ufs: Fix regulator operations and
 remove "<name>-fixed-regulator" device tree property
Date: Thu, 28 Mar 2019 09:21:15 +0800
Message-ID: <1553736075.30977.97.camel@mtkswgap22>
References: <1553680707-28579-1-git-send-email-stanley.chu@mediatek.com>
 <CAGOxZ51zdtoLz=E_vmpwt+2wTJq32yUQa=h_OiV7qO1N-c=NUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <CAGOxZ51zdtoLz=E_vmpwt+2wTJq32yUQa=h_OiV7qO1N-c=NUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Alim Akhtar <alim.akhtar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, marc.w.gonzalez-GANU6spQydw@public.gmane.org, chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, Kuohong Wang <kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Avri Altman <avri.altman-Sjgp3cTcYWE@public.gmane.org>, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pedro Sousa <pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Alim,

On Wed, 2019-03-27 at 22:48 +0530, Alim Akhtar wrote:
> Hi Stanley,
> Please collect all the {review/acked}-by tags when reposting so that
> people are aware which all patches need to review.
> https://www.spinics.net/lists/linux-scsi/msg128818.html

Sorry it's my mistake to miss some tags in reposted patch.
Will fix it in next version.

> This series looks good, it will be if we get a Tested-by as well.
> For this series
> Acked-by: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Thanks so much for review.

> 
> On Wed, Mar 27, 2019 at 3:29 PM Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org> wrote:
> >
> > Hi,
> >
> > Resend this patch series for review.
> >
> > This version (v3) fixed and added more details in commit messages, and added one patch to fix "undefined voltage range" issue as well.
> >
> > This patch series fixes UFS regulator operations, including voltage and current (re-)configuration flow during UFS initialization and power mode switching.
> >
> > In the end, remove "<name>-fixed-regulator" device tree property because it is not necessary anymore after these fixes.
> >
> > V3:
> > - Fix and add more details in commit messages.
> > - Add one patch "scsi: ufs: Avoid configuring undefined voltage range on a regulator".
> >
> > V2:
> > - Add two patches to prepare to and remove "<name>-fixed-regulator" device tree property.
> > - Add more details on patch "scsi: ufs: remove unused min_uA field in struct ufs_vreg" (Marc Gonzalez).
> >
> > Stanley Chu (5):
> >   scsi: ufs: Remove unused min_uA field in struct ufs_vreg
> >   scsi: ufs: Avoid configuring regulator with undefined voltage range
> >   scsi: ufs: Fix regulator load and icc-level configuration
> >   scsi: ufs: Change "<name>-max-microamp" to non-mandatory property
> >   scsi: ufs: Remove "<name>-fixed-regulator" device tree property
> >
> >  drivers/scsi/ufs/ufs.h           |  1 -
> >  drivers/scsi/ufs/ufshcd-pltfrm.c | 14 +++-----------
> >  drivers/scsi/ufs/ufshcd.c        | 28 ++++++++++++++++++++--------
> >  3 files changed, 23 insertions(+), 20 deletions(-)
> >
> > --
> > 2.18.0
> >
> 
> 
Thanks,
Stanley
