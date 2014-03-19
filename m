From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND 4/7] ipr: Get rid of superfluous call to
 pci_disbale_msi/msix()
Date: Wed, 19 Mar 2014 12:55:06 -0700
Message-ID: <1395258906.2185.43.camel@dabdike.int.hansenpartnership.com>
References: <20140312210845.384489953@vmlinux.vnet.ibm.com>
	 <20140312210906.288887472@vmlinux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36339 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbaCSTzJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2014 15:55:09 -0400
In-Reply-To: <20140312210906.288887472@vmlinux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@vmlinux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, bjking1@us.ibm.com, Alexander Gordeev <agordeev@redhat.com>, Brian King <brking@linux.vnet.ibm.com>

On Wed, 2014-03-12 at 16:08 -0500, wenxiong@vmlinux.vnet.ibm.com wrote:
> From: Alexander Gordeev <agordeev@redhat.com>
> 
> There is no need to call pci_disable_msi() or pci_disable_msix()
> in case the call to pci_enable_msi() or pci_enable_msix() failed.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Acked-by: Brian King <brking@linux.vnet.ibm.com>
> ---

This needs a Signed-off-by: from you as well, since you transmitted the
patch to me.  I assume it was just omitted in error and have added it in
the git repository.

James


