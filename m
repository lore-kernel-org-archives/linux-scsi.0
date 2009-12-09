From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] SCSI/libsrp: fix bug in ADDITIONAL CDB LENGTH
 interpretation
Date: Thu, 10 Dec 2009 08:37:39 +0900
Message-ID: <20091210083727O.fujita.tomonori@lab.ntt.co.jp>
References: <200912091952.19978.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39268 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758647AbZLIXhw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Dec 2009 18:37:52 -0500
In-Reply-To: <200912091952.19978.bart.vanassche@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bart.vanassche@gmail.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, fujita.tomonori@lab.ntt.co.jp, brking@linux.vnet.ibm.com

On Wed, 9 Dec 2009 19:52:19 +0100
Bart Van Assche <bart.vanassche@gmail.com> wrote:

> Fix a bug in the interpretation of the ADDITIONAL CDB LENGTH (add_cdb_len)
> field of SRP_CMD requests. According to the SRP specification, the layout
> of this single-byte field is as follows:
> * Bits 0 and 1 are reserved.
> * Bits 2 to 7 represent the ADDITIONAL CDB LENGTH field, symbolically
>   represented as n.
> * Still according to the SRP specification, the ADDITIONAL CDB section
>   takes 4*n bytes.
> 
> Currently libsrp is only used by the ibmvscsi driver. Since the ibmvscsi
> driver doesn't support large CDB's, this bug hasn't caused any problems yet.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
> Cc: James E.J. Bottomley <James.Bottomley@suse.de>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Brian King <brking@linux.vnet.ibm.com>

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Thanks,
