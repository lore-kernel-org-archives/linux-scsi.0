From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [patch] aacraid: controller hangs if kernel uses non-default
 ASPM policy
Date: Fri, 11 Nov 2011 14:12:49 +0000
Message-ID: <20111111141249.GA11327@srcf.ucam.org>
References: <4EBCEDF8.2090403@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:39326 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab1KKOMy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2011 09:12:54 -0500
Content-Disposition: inline
In-Reply-To: <4EBCEDF8.2090403@parallels.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasily Averin <vvs@parallels.com>
Cc: linux-scsi@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, James Bottomley <jbottomley@parallels.com>, Mark Salyzyn <mark_salyzyn@us.xyratex.com>

On Fri, Nov 11, 2011 at 01:42:16PM +0400, Vasily Averin wrote:
> Patch from RHEL6 kernel
> - [scsi] aacraid: Disable ASPM by default (Matthew Garrett) [599735]
> aacraid controller hangs if kernel uses non-default ASPM policy
> 
> Signed-off-by:	Vasily Averin <vvs@sw.ru>
> CC: Matthew Garrett <mjg@redhat.com>

Checking the Windows drivers indicates that they disable ASPM under all 
circumstances, so:

Acked-by: Matthew Garrett <mjg@redhat.com>
