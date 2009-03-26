From: Madhukar G <madhukar.linux@gmail.com>
Subject: Re: Understanding SAS
Date: Thu, 26 Mar 2009 10:10:15 +0530
Message-ID: <e79524560903252140y32e4689brcdbba6b4e5139aba@mail.gmail.com>
References: <e79524560903240534x7b3c5376uc75bda4a3f65c170@mail.gmail.com>
	 <FE3F06125A99254E8D92161AA4569C6F06A98B5F@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:45633 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZCZEkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 00:40:18 -0400
Received: by wa-out-1112.google.com with SMTP id j5so234605wah.21
        for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2009 21:40:15 -0700 (PDT)
In-Reply-To: <FE3F06125A99254E8D92161AA4569C6F06A98B5F@sc-exch02.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ying Chu <jasonchu@marvell.com>
Cc: linux-scsi@vger.kernel.org

Thanks for the info. Where can i download the mvsas patch. Currently
i'm using 2.6.28 kernel.

Regards,
Madhukar

2009/3/26 Ying Chu <jasonchu@marvell.com>:
> You can consult the new mvsas patch set pending to kernel.
>
>
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org] On Behalf Of Madhukar G
> Sent: 2009=C4=EA3=D4=C224=C8=D5 20:35
> To: linux-scsi@vger.kernel.org
> Subject: Understanding SAS
>
> Hi All,
>
> I'm new to SAS architecture. I have sas1r10.pdf with me for understan=
ding the protocol. I'm looking at the sources available at scsi/libsas.
>
> I was looking at task management function sequence and non-data comma=
nd sequence for SSP frames in the specification. But i could not map th=
e same in source code. Can some help me understand in which functions t=
hese sequences of SSP frames are handled.
>
> Any help is much appreciated.
>
> Thank You.
>
> Regards,
> Madhukar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in the body of a message to majordomo@vger.kernel.org More majordomo i=
nfo at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
