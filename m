From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH][2.5] Aic7xxx and EISA API
Date: Mon, 19 May 2003 09:43:27 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1328050000.1053359007@aslan.btc.adaptec.com>
References: <wrpel2v54y9.fsf@hina.wild-wind.fr.eu.org>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:57283 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S262319AbTESPag
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 11:30:36 -0400
In-Reply-To: <wrpel2v54y9.fsf@hina.wild-wind.fr.eu.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: mzyngier@freesurf.fr
Cc: linux-scsi@vger.kernel.org

> Justin,
> 
> This patch updates the aic7xxx driver to use the EISA probing API. It
> also includes the fix you provided for TWIN boards.
> 
> I'd appreciate any comment.

I will perform a more careful review later today, but my main concern
about this change is that it looks like it will prevent the probing of
VLB cards in non-EISA systems.

--
Justin

