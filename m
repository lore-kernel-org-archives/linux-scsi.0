From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH 31/41] scsi: mpt3sas: mpt3sas_scsih: Mark expected switch fall-through
Date: Thu, 20 Dec 2018 09:49:04 +0530
Message-ID: <CA+RiK64O=zLKdbF4KRXYGD23qi3Ajv5S2oPoKuSbksbMwOHu_A@mail.gmail.com>
References: <cover.1543374820.git.gustavo@embeddedor.com> <892c3e5e27213c1c2f3da128afe958429bbef672.1543374820.git.gustavo@embeddedor.com>
 <4bce4543-ae65-8dfa-cbe6-405d78003129@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4bce4543-ae65-8dfa-cbe6-405d78003129@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Hi Gustavo,

This patch may not apply smoothly over 4.21/scsi-queue.
Our previous patch for Aero had some changes in this switch case.
Can you resend this patch with latest code base ?

Thanks,
Suganath prabu


On Thu, Dec 20, 2018 at 5:37 AM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> Hi,
>
> Friendly ping:
>
> Who can ack or review this patch, please?
>
> Thanks
> --
> Gustavo
>
> On 11/27/18 10:32 PM, Gustavo A. R. Silva wrote:
> > In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> > where we are expecting to fall through.
> >
> > Addresses-Coverity-ID: 1475400 ("Missing break in switch")
> > Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> > ---
> >   drivers/scsi/mpt3sas/mpt3sas_scsih.c | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > index 5b9806d0719e..920b80ce4748 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > @@ -10370,6 +10370,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >               case MPI26_MFGPAGE_DEVID_CFG_SEC_3916:
> >                       dev_info(&pdev->dev,
> >                           "HBA is in Configurable Secure mode\n");
> > +                     /* fall through */
> >               case MPI26_MFGPAGE_DEVID_SAS3508:
> >               case MPI26_MFGPAGE_DEVID_SAS3508_1:
> >               case MPI26_MFGPAGE_DEVID_SAS3408:
> >
