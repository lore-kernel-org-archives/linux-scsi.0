From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: make device_mutex and device_list static
Date: Thu, 06 Jul 2017 21:29:24 -0700
Message-ID: <1499401764.30628.17.camel@haakon3.risingtidesystems.com>
References: <20170704084419.10800-1-colin.king@canonical.com>
         <595D2CC4.3090303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <595D2CC4.3090303@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>
Cc: Colin King <colin.king@canonical.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-07-05 at 13:15 -0500, Mike Christie wrote:
> On 07/04/2017 03:44 AM, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > Variables device_mutex and device_list static are local to the source,
> > so make them static.
> > 
> > Cleans up sparse warnings:
> > "symbol 'device_list' was not declared. Should it be static?"
> > "symbol 'device_mutex' was not declared. Should it be static?"
> > 
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  drivers/target/target_core_device.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> > index 3ae8fbf01bdf..bbcef3bc66c8 100644
> > --- a/drivers/target/target_core_device.c
> > +++ b/drivers/target/target_core_device.c
> > @@ -49,8 +49,8 @@
> >  #include "target_core_pr.h"
> >  #include "target_core_ua.h"
> >  
> > -DEFINE_MUTEX(device_mutex);
> > -LIST_HEAD(device_list);
> > +static DEFINE_MUTEX(device_mutex);
> > +static LIST_HEAD(device_list);
> >  static DEFINE_IDR(devices_idr);
> >  
> >  static struct se_hba *lun0_hba;
> > 
> 
> My fault. Thanks.
> 
> Reviewed-by: Mike Christie <mchristi@redhat.com>

Applied.

Thanks Colin + MNC.
