From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH 1/3] isci: isci: remove SCSI host before detaching from
 SAS transport
Date: Thu, 5 Nov 2015 12:36:04 +0100
Message-ID: <CAMGffE=gYwPmBYJg496oOrgONTPc=R3SRDkhC3yrdA1M8YbGFw@mail.gmail.com>
References: <CAMGffE=F6PuKNV1vgesePQ29GJUCoZaScq01pT-gqROjV4DL9w@mail.gmail.com>
 <20151105102327.GA21731@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:34076 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031023AbbKELgZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 06:36:25 -0500
Received: by wmnn186 with SMTP id n186so11532407wmn.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2015 03:36:23 -0800 (PST)
In-Reply-To: <20151105102327.GA21731@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, intel-linux-scu@intel.com, brood <brood@attotech.com>

Hi Christoph,

On Thu, Nov 5, 2015 at 11:23 AM, Christoph Hellwig <hch@lst.de> wrote:
> Hi Jack,
>
> all three patches look fine to me, but it seems like your mailer mang=
led
> the whitespaces.

Thanks, I've resend with git send-email.
Sorry for inconvenient.

--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin
Tel: +49 30 5770083-42
=46ax: +49 30 5770085-98
Email: jinpu.wang@profitbricks.com
URL: http://www.profitbricks.de

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B.
Gesch=C3=A4ftsf=C3=BChrer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
