From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: RE: [PATCH 3/3] scsi: ufs: retry if the link-startup fails
Date: Tue, 8 Jul 2014 13:18:27 +0300
Message-ID: <00d701cf9a95$f7f3ac20$e7db0460$@codeaurora.org>
References: <1404206559-21445-1-git-send-email-draviv@codeaurora.org> <1404206559-21445-4-git-send-email-draviv@codeaurora.org> <20140707103719.GA7810@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:49639 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaGHKSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2014 06:18:33 -0400
In-Reply-To: <20140707103719.GA7810@infradead.org>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com

> Did you plan to change the arguments to ufshcd_is_device_present in a=
 later patch?
I guess I overlooked it, thanks for bringing it to my attention.
I will resend the series without this patch.

Thanks,
Dolev
--=20
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a mem=
ber of Code Aurora Forum, hosted by The Linux Foundation


-----Original Message-----
=46rom: Christoph Hellwig [mailto:hch@infradead.org]=20
Sent: Monday, July 07, 2014 1:37 PM
To: Dolev Raviv
Cc: James.Bottomley@HansenPartnership.com; linux-scsi@vger.kernel.org; =
linux-scsi-owner@vger.kernel.org; sthumma@codeaurora.org; linux-arm-msm=
@vger.kernel.org; santoshsy@gmail.com
Subject: Re: [PATCH 3/3] scsi: ufs: retry if the link-startup fails

This produces a compiler warning for me that looks serious:

=2E./drivers/scsi/ufs/ufshcd.c: In function =C3=A2=E2=82=AC=CB=9Cufshcd=
_link_startup=C3=A2=E2=82=AC=E2=84=A2:
=2E./drivers/scsi/ufs/ufshcd.c:1938:3: warning: passing argument 1 of =C3=
=A2=E2=82=AC=CB=9Cufshcd_is_device_present=C3=A2=E2=82=AC=E2=84=A2 make=
s integer from pointer without a cast [enabled by default]
=2E./drivers/scsi/ufs/ufshcd.c:185:19: note: expected =C3=A2=E2=82=AC=CB=
=9Cu32=C3=A2=E2=82=AC=E2=84=A2 but argument is of type =C3=A2=E2=82=AC=CB=
=9Cstruct ufs_hba *=C3=A2=E2=82=AC=E2=84=A2

Did you plan to change the arguments to ufshcd_is_device_present in a l=
ater patch?

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
