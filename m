From: Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH 05/10] drivers/scsi/arcmsr: Fix continuation line formats
Date: Mon, 1 Feb 2010 20:07:24 +0100
Message-ID: <201002012007.25498.elendil@planet.nl>
References: <cover.1264967493.git.joe@perches.com> <cover.1264967493.git.joe@perches.com> <m2n.s.201002011906064544@fjphome.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-To: <m2n.s.201002011906064544@fjphome.nl>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: support@areca.com.tw, linux-kernel@vger.kernel.org, James.Bottomley@suse.de, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> String constants that are continued on subsequent lines with \
> are not good.
> Fix rebulid/rebuild typos
>
> Signed-off-by: Joe Perches <joe@perches.com>

Hmmm. Would it be an idea to also get rid of all the trailing spaces in=
 the
printks, or is that for another cleanup?

If you'd prefer a separate patch, I can do it.

A few random examples:

> =A0drivers/scsi/arcmsr/arcmsr_hba.c | =A0 49
> +++++++++++++++++-------------------- 1 files changed, 23 insertions(=
+),
> 26 deletions(-)
>
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c
> b/drivers/scsi/arcmsr/arcmsr_hba.c index 47d5d19..a0378d5 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
[...]
+                       printk(KERN_NOTICE "arcmsr%d: wait 'flush adapt=
er cache' timeout, retry count down =3D %d \n",
+                              acb->host->host_no, retry_count);
[...]
+               printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb co=
mmand done acb =3D '0x%p'"
                                "ccb =3D '0x%p' ccbacb =3D '0x%p' start=
done =3D 0x%x"
                                " ccboutstandingcount =3D %d \n"
                                , acb->host->host_no
[...]
                printk(KERN_NOTICE
+                       "arcmsr%d: wait 'stop adapter background rebuil=
d' timeout \n"
                        , acb->host->host_no);
[...]
+                       printk(KERN_NOTICE "arcmsr%d: 'can not set dive=
r mode \n"
