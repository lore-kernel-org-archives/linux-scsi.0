From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: aacraid controller hangs if kernel uses non-default ASPM policy
Date: Fri, 11 Nov 2011 13:09:38 +0000
Message-ID: <20111111130938.GA10242@srcf.ucam.org>
References: <4EBCEDED.7030907@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:44576 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab1KKNJo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2011 08:09:44 -0500
Content-Disposition: inline
In-Reply-To: <4EBCEDED.7030907@parallels.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasily Averin <vvs@parallels.com>
Cc: linux-scsi@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, James Bottomley <jbottomley@parallels.com>, Mark Salyzyn <mark_salyzyn@us.xyratex.com>

Yeah, sorry about that, it's something that was on my list to deal with. 
Disabling ASPM entirely on aacraid really isn't a desirable outcome - 
it'd be significantly better to identify which chipsets are broken with 
it enabled and then only disable those.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
