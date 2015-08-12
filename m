From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH][SCSI] hptiop: Support HighPoint RR36xx HBAs and Support
 SAS tape and SAS media changer
Date: Wed, 12 Aug 2015 13:15:29 -0700
Message-ID: <1439410529.2825.92.camel@HansenPartnership.com>
References: <000601d0bad8$3d1716d0$b7454470$@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53084 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162AbbHLUPa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Aug 2015 16:15:30 -0400
In-Reply-To: <000601d0bad8$3d1716d0$b7454470$@highpoint-tech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux <linux@highpoint-tech.com>
Cc: 'Hannes Reinecke' <hare@suse.de>, linux-scsi@vger.kernel.org, 'Steve Chang' <ychang@highpoint-tech.com>

On Fri, 2015-07-10 at 14:18 +0800, linux wrote:
> Hi,
>  =20
>    We found that the updated hptiop driver (version v1.10.0) was not =
embedded into kernel 4.2 RC1, is there something wrong with the submitt=
ed patch or when would the patch be accepted?
>=20
>    If there is any question, please do not hesitate to let us know.

I've got it now; it's giving one error:

drivers/scsi/hptiop.c: In function =E2=80=98hptiop_probe=E2=80=99:
drivers/scsi/hptiop.c:1495:1: warning: label =E2=80=98free_request_irq=E2=
=80=99 defined
but not used

So I've removed that label.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
