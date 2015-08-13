From: "linux" <linux@highpoint-tech.com>
Subject: Re: [PATCH][SCSI] hptiop: Support HighPoint RR36xx HBAs and Support SAS tape and SAS media changer
Date: Thu, 13 Aug 2015 09:00:47 +0800
Message-ID: <007901d0d563$8118f740$834ae5c0$@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.ord1c.emailsrvr.com ([108.166.43.102]:38188 "EHLO
	smtp102.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182AbbHMBBH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Aug 2015 21:01:07 -0400
Content-Language: zh-cn
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: 'Hannes Reinecke' <hare@suse.de>, linux-scsi@vger.kernel.org, 'Steve Chang' <ychang@highpoint-tech.com>

Dear James,

    Sorry, it's our mistake. And thank you for help us to fix it.
    If there is any question, please do not hesitate to let us know.

Best Regards,
HighPoint Linux Team

Sender: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]=20
Send Time: 2015/8/13 4:15
Receiver: linux
CC: 'Hannes Reinecke'; linux-scsi@vger.kernel.org; 'Steve Chang'
Subject: Re: [PATCH][SCSI] hptiop: Support HighPoint RR36xx HBAs and Su=
pport SAS tape and SAS media changer

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
