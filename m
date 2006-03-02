From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Subject: Re: Question: how to map SCSI data DMA address to virtual address?
Date: Thu, 2 Mar 2006 12:09:02 -0500
Message-ID: <Pine.LNX.4.61.0603021203280.14257@chaos.analogic.com>
References: <9738BCBE884FDB42801FAD8A7769C2651420C1@NAMAIL1.ad.lsil.com>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from spirit.analogic.com ([204.178.40.4]:31496 "EHLO
	spirit.analogic.com") by vger.kernel.org with ESMTP
	id S1752015AbWCBRJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2006 12:09:03 -0500
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C2651420C1@NAMAIL1.ad.lsil.com>
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: "Ju, Seokmann" <Seokmann.Ju@engenio.com>, Linux kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org


On Thu, 2 Mar 2006, Ju, Seokmann wrote:

> Hi,
>
> In the 'scsi_cmnd' structure, there are two entries holding address
> information for data to be transferred. One is 'request_buffer' and the
> other one is 'buffer'.
> In case of 'use_sg' is non-zero, those entries indicates the address of
> the scatter-gather table.
>
> Is there way to get virtual address (so that the data could be accessed
> by the driver) of the actual data in the case of 'use_sg' is non-zero?
>
> Any comments would be appreciated.
>
>
> Thank you,
>
> Seokmann
> -

There is a macro for this purpose. However, for experiments, in
the kernel, you can add PAGE_OFFSET (0xC00000000) to get the virtual
address. The macro is __va(a), its inverse is __pa(a).

Careful. These things can change.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.15.4 on an i686 machine (5589.54 BogoMips).
Warning : 98.36% of all statistics are fiction, book release in April.
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
