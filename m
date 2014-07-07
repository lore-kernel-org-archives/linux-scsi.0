From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] scsi: ufs: retry if the link-startup fails
Date: Mon, 7 Jul 2014 03:37:19 -0700
Message-ID: <20140707103719.GA7810@infradead.org>
References: <1404206559-21445-1-git-send-email-draviv@codeaurora.org>
 <1404206559-21445-4-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41233 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaGGKhT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2014 06:37:19 -0400
Content-Disposition: inline
In-Reply-To: <1404206559-21445-4-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com

This produces a compiler warning for me that looks serious:

=2E./drivers/scsi/ufs/ufshcd.c: In function =E2=80=98ufshcd_link_startu=
p=E2=80=99:
=2E./drivers/scsi/ufs/ufshcd.c:1938:3: warning: passing argument 1 of
=E2=80=98ufshcd_is_device_present=E2=80=99 makes integer from pointer w=
ithout a
cast [enabled by default]
=2E./drivers/scsi/ufs/ufshcd.c:185:19: note: expected =E2=80=98u32=E2=80=
=99 but
argument is of type =E2=80=98struct ufs_hba *=E2=80=99

Did you plan to change the arguments to ufshcd_is_device_present in
a later patch?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
