From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [RFC PATCH scsi] aacraid: aac_release_resources() can be static
Date: Tue, 24 Nov 2015 13:51:10 +0100
Message-ID: <1448369470.2877.31.camel@suse.de>
References: <201511101352.WifvAYu2%fengguang.wu@intel.com>
	 <20151110055906.GA116383@lkp-hsx03>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbbKXMvM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:51:12 -0500
In-Reply-To: <20151110055906.GA116383@lkp-hsx03>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, James Bottomley <JBottomley@Odin.com>, Tomas Henzl <thenzl@redhat.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Karthikeya Sunkesula <Karthikeya.Sunkesula@pmcs.com>

On Tue, 2015-11-10 at 13:59 +0800, kbuild test robot wrote:
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
> =C2=A0linit.c |=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/aacraid/linit.c
> b/drivers/scsi/aacraid/linit.c
> index 37375cf..7724583f 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -1318,7 +1318,7 @@ static int aac_probe_one(struct pci_dev *pdev,
> const struct pci_device_id *id)
> =C2=A0}
> =C2=A0
> =C2=A0#if (defined(CONFIG_PM))
> -void aac_release_resources(struct aac_dev *aac)
> +static void aac_release_resources(struct aac_dev *aac)
> =C2=A0{
> =C2=A0	int i;
> =C2=A0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
=20
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-in=
fo.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
