From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Compaq Fiber Channel Array RM4000 / 2.6.16 kernel patch
Date: Thu, 30 Mar 2006 08:13:58 -0800
Message-ID: <20060330161358.GA3237@us.ibm.com>
References: <1143659029.3248.42.camel@mulgrave.il.steeleye.com> <Pine.GSO.4.64.0603292125370.4009@filebunker.xip.at> <1143666681.3248.48.camel@mulgrave.il.steeleye.com> <Pine.GSO.4.64.0603301252100.595@filebunker.xip.at> <20060330125816.GG13590@parisc-linux.org> <Pine.GSO.4.64.0603301523130.6412@filebunker.xip.at> <1143729995.3328.1.camel@mulgrave.il.steeleye.com> <Pine.GSO.4.64.0603301657170.6412@filebunker.xip.at> <1143731368.3328.3.camel@mulgrave.il.steeleye.com> <Pine.GSO.4.64.0603301719200.6412@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:17589 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751216AbWC3QOX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Mar 2006 11:14:23 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k2UGECxP030801
	for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2006 11:14:12 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2UGE3HP231626
	for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2006 11:14:03 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k2UGE297020998
	for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2006 11:14:02 -0500
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.0603301719200.6412@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <matthew@wil.cx>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Mar 30, 2006 at 05:54:48PM +0200, Ingo Flaschberger wrote:

> +	{"COMPAQ", "ARRAY CONTROLLER", "2.60", BLIST_SPARSELUN | BLIST_LARGELUN |
> +		BLIST_MAX_512K | BLIST_REPORTLUN}, /* Compaq RA4x00 */
> +	{"COMPAQ", "LOGICAL VOLUME", "2.60", BLIST_MAX_512K}, /* Compaq RA4x00 */
>  	{"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN},

Related to Matthew's question ...

The revision field is not used, so you should combine the above into one
entry, else the first one will always be used.

-- Patrick Mansfield
