From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND 4/7] ipr: Get rid of superfluous call to
 pci_disbale_msi/msix()
Date: Wed, 19 Mar 2014 13:57:23 -0700
Message-ID: <1395262643.2185.47.camel@dabdike.int.hansenpartnership.com>
References: <20140312210845.384489953@vmlinux.vnet.ibm.com>
	 <20140312210906.288887472@vmlinux.vnet.ibm.com>
	 <1395258906.2185.43.camel@dabdike.int.hansenpartnership.com>
	 <5329FD69.8060100@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36768 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753933AbaCSU51 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2014 16:57:27 -0400
In-Reply-To: <5329FD69.8060100@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Wendy Xiong <wenxiong@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Alexander Gordeev <agordeev@redhat.com>

On Wed, 2014-03-19 at 15:26 -0500, Brian King wrote:
> On 03/19/2014 02:55 PM, James Bottomley wrote:
> > On Wed, 2014-03-12 at 16:08 -0500, wenxiong@vmlinux.vnet.ibm.com wrote:
> >> From: Alexander Gordeev <agordeev@redhat.com>
> >>
> >> There is no need to call pci_disable_msi() or pci_disable_msix()
> >> in case the call to pci_enable_msi() or pci_enable_msix() failed.
> >>
> >> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> >> Acked-by: Brian King <brking@linux.vnet.ibm.com>
> >> ---
> > 
> > This needs a Signed-off-by: from you as well, since you transmitted the
> > patch to me.  I assume it was just omitted in error and have added it in
> > the git repository.
> 
> Correcting Wendy's email address...

Humf, that means it's wrong in the Author field of the git commits
too ... please fix whatever script is sending the wrong email address.

Thanks,

James


