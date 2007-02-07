From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] scsi: megaraid_sas - stop cmd processing if
 hw_crit_error is set
Date: Wed, 7 Feb 2007 13:17:53 -0800
Message-ID: <20070207131753.1b631421.akpm@linux-foundation.org>
References: <1170798564.10482.12.camel@dumbo>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37276 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422778AbXBGVR6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Feb 2007 16:17:58 -0500
In-Reply-To: <1170798564.10482.12.camel@dumbo>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumant Patro <sumantp@lsil.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com

On Tue, 06 Feb 2007 13:49:24 -0800
Sumant Patro <sumantp@lsil.com> wrote:

> +	/* Don't process if we have already declared adapter dead */
> +	if(instance->hw_crit_error)

Preferred kernel coding style is "if (".

> [p1-crit_err.patch  text/x-patch (1.3KB)]

argh.  Please don't send two copies of the patch in the email.  Because the
result applies happily with `patch --dry-run' and then creates a great mess
when you try to apply the patch for real.

