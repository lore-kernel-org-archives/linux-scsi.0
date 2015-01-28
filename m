From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH 08/17] ibmvscsi: Fix bidi command test
Date: Wed, 28 Jan 2015 14:42:28 -0800
Message-ID: <54C965D4.1080704@linux.vnet.ibm.com>
References: <54C2390A.3000700@sandisk.com> <54C23A2F.1090005@sandisk.com> <54C80CE8.40506@linux.vnet.ibm.com> <54C8965D.2040008@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35883 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbbA2BM4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2015 20:12:56 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
	Wed, 28 Jan 2015 17:42:33 -0500
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 54B9938C803B
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2015 17:42:31 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t0SMgVqW28049488
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2015 22:42:31 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t0SMgUkj010329
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2015 17:42:31 -0500
In-Reply-To: <54C8965D.2040008@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Nathan Fontenot <nfont@linux.vnet.ibm.com>

On 01/27/2015 11:57 PM, Bart Van Assche wrote:

[snip]

> 
> Hello Tyrel,
> 
> Since the ibmvscsi driver does not set QUEUE_FLAG_BIDI neither the code
> under "case DMA_BIDIRECTIONAL" nor the code under "if
> (scsi_bidi_cmnd(cmd))" is ever executed. The only reason why I proposed
> this change is to avoid that an author of another SCSI LLD driver would
> use the code that compares sc_data_direction with DMA_BIDIRECTIONAL as
> an example.
> 
> BTW, had you already noticed that Christoph Hellwig proposed to modify
> the SCSI core such that sc_data_direction is set to DMA_BIDIRECTIONAL
> for bidi commands ? I'd like to rework this patch series accordingly.
> With that approach no changes are necessary in the ibmvscsi driver.
> 
> Bart.
> 
> 

I only saw the ibmvscsi patch on my way out of the office yesterday
because Brian King forwarded it to me. After looking at the full
patchset I now understand the intent. I did see Christoph's proposal and
agree with the logic of setting DMA_BIDIRECTIONAL for bidi commands.

-Tyrel

