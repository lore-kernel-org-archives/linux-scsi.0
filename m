From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Data accessors more patches
Date: Thu, 12 Jul 2007 16:13:52 +0300
Message-ID: <46962910.4060403@panasas.com>
References: <468BE4CE.80402@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:32599 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932371AbXGLNOE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 09:14:04 -0400
In-Reply-To: <468BE4CE.80402@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> As a reply to this email I will send some more files
> converted to new data accessors, and attempts of cleanups
> of: !use_sg code path's, use of scsi_for_each_sg and use
> of scsi_{,un}map_dma().
> 
> some of these files are in scsi-ml core but they can be converted
> now, and are not at all dependent on implementation.
> 
> libata-scsi.c	- code will now work with scsi_sgtable but farther cleanup is needed.
> scsi.c 		- some prints might as well use accessors now.
> scsi_debug.c	- This is actually a scsi LLD. Normal conversion.
> 
> The rest of the converted files I will send in the following days
> 
> Boaz
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Tomo hi.

I would like your Signed-off-by: on all of these. Since you
have more experience with these cleanups.

Thanks

