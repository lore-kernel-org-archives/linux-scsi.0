From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/2] RE: How to add/drop SCSI drives from within the
	drive r?
Date: Thu, 09 Dec 2004 21:24:06 -0600
Message-ID: <1102649046.3814.6.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E570230CA9F@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:36234 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261555AbULJDZM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 22:25:12 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230CA9F@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: Matt Domsch <Matt_Domsch@Dell.com>, "'brking@us.ibm.com'" <brking@us.ibm.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, Andrew Morton <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>

On Thu, 2004-12-09 at 20:18 -0500, Bagalkote, Sreenivas wrote:
> diff -Naur a/Documentation/scsi/ChangeLog.megaraid
> b/Documentation/scsi/ChangeLog.megaraid
> --- a/Documentation/scsi/ChangeLog.megaraid	2004-12-07
> 16:40:23.000000000 -0500
> +++ b/Documentation/scsi/ChangeLog.megaraid	2004-12-09
> 19:05:47.795231320 -0500
> @@ -1,3 +1,10 @@
> +Release Date	: Thu Dec  9 19:02:14 EST 2004 - Sreenivas Bagalkote
> <sreenib@lsil.com>
> +
> +Current Version	: 2.20.4.1 (scsi module), 2.20.2.3 (cmm module)
> +Older Version	: 2.20.4.1 (scsi module), 2.20.2.2 (cmm module)
> +
> +i.	Fix a bug in kioc's dma buffer deallocation

This patch won't apply --- it looks like your mailer broke the lines.
Could you resend it?

Thanks,

James


