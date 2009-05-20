From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ipr: ipr_remove() marked __devexit
Date: Wed, 20 May 2009 19:58:21 +0000
Message-ID: <1242849501.2881.80.camel@localhost.localdomain>
References: <1237839145.13011.54.camel@zeppelin.austin.ibm.com>
	 <1239995314.6143.1.camel@zeppelin.austin.ibm.com>
	 <1240020307.5763.1.camel@mulgrave>
	 <1240235787.7458.13.camel@zeppelin.austin.ibm.com>
	 <1240237018.3315.14.camel@mulgrave.int.hansenpartnership.com>
	 <1240408230.8289.3.camel@zeppelin.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53972 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755578AbZETT6R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 May 2009 15:58:17 -0400
In-Reply-To: <1240408230.8289.3.camel@zeppelin.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kleber S. Souza" <klebers@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2009-04-22 at 10:50 -0300, Kleber S. Souza wrote:
> @@ -7850,7 +7850,7 @@ static struct pci_driver ipr_driver = {
>         .name = IPR_NAME,
>         .id_table = ipr_pci_table,
>         .probe = ipr_probe,
> -       .remove = ipr_remove,
> +       .remove = __devexit_p(ipr_remove),
>         .shutdown = ipr_shutdown,
>         .err_handler = &ipr_err_handler,
>  };

This entire hunk has spaces for tabs.  Since it's only one line, I fixed
it up manually, but please fix your email tool for next time.

Thanks,

James


