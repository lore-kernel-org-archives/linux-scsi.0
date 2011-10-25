From: Peter Chang <dpf@google.com>
Subject: Re: mtpbase ioc error codes?
Date: Tue, 25 Oct 2011 05:44:27 -0700
Message-ID: <CAF2xp_GXtEj626_cZ=5=3GOVBPs_-hNEbiCeCfhzd8wbh4YjnQ@mail.gmail.com>
References: <CABzZrXcCRP2q2q9C7x0NPJPjxy=wqUdm0_MDLLdYZ0chPoOoug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:57245 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab1JYMou convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2011 08:44:50 -0400
Received: from hpaq13.eem.corp.google.com (hpaq13.eem.corp.google.com [172.25.149.13])
	by smtp-out.google.com with ESMTP id p9PCinOC002309
	for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2011 05:44:49 -0700
Received: from gyd10 (gyd10.prod.google.com [10.243.49.202])
	by hpaq13.eem.corp.google.com with ESMTP id p9PCfeLV003384
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2011 05:44:47 -0700
Received: by gyd10 with SMTP id 10so632453gyd.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2011 05:44:47 -0700 (PDT)
In-Reply-To: <CABzZrXcCRP2q2q9C7x0NPJPjxy=wqUdm0_MDLLdYZ0chPoOoug@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eero Volotinen <eero.volotinen@iki.fi>
Cc: linux-scsi@vger.kernel.org

Le 25 octobre 2011 02:15, Eero Volotinen <eero.volotinen@iki.fi> a =E9c=
rit :
> My server reports following failures to kernel:
>
> mptbase: ioc0: WARNING - IOC is in FAULT state (1600h)!!!

  IFAULT_IOP_MID_OUT_OF_RANGE_SCSIIO_COMP_1 - Encountered an invalid mi=
d number.

\p
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
