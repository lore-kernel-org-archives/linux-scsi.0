From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/1] libsrp: Fix oops on ibmvscsis module remove
Date: Sun, 27 Mar 2011 17:51:29 +0900
Message-ID: <20110327175103D.fujita.tomonori@lab.ntt.co.jp>
References: <201103242016.p2OKGZsc014250@d03av05.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:36516 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab1C0Ivp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Mar 2011 04:51:45 -0400
In-Reply-To: <201103242016.p2OKGZsc014250@d03av05.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Thu, 24 Mar 2011 15:16:35 -0500
Brian King <brking@linux.vnet.ibm.com> wrote:

> 
> While testing the ibmvscsis driver, an oops was observed on module
> remove. This occurred due to some confusion regarding what layer
> owns the drvdata in the struct device for an ibmvscsis device.
> libsrp was overriding what ibmvscsis had already setup, so on
> module remove we go off a bad pointer. Since libsrp appears
> only to setup drvdata and never read the value, lets just remove
> setting it in libsrp and let the server driver own the field.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/libsrp.c |    2 --
>  1 file changed, 2 deletions(-)

Oops, thanks. This change needs to be merged with ibmvscsis.

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
