From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] VMW_PVSCSI: Fix the issue of DMA-API related warnings.
Date: Thu, 11 Jun 2015 06:23:54 -0700
Message-ID: <1434029034.2228.3.camel@HansenPartnership.com>
References: <1395425313.8462.1254.camel@arvindkumar-dev1.eng.vmware.com>
	 <CA+5PVA5tghb=ZhUHwt7A6+yK1hmcFzPbwYL1BN2wkd76p=o54Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56583 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753173AbbFKNX4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2015 09:23:56 -0400
In-Reply-To: <CA+5PVA5tghb=ZhUHwt7A6+yK1hmcFzPbwYL1BN2wkd76p=o54Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Arvind Kumar <arvindkumar@vmware.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, VMware PV-Drivers <pv-drivers@vmware.com>, Linus Torvalds <torvalds@linux-foundation.org>

On Thu, 2015-06-11 at 08:32 -0400, Josh Boyer wrote:
> On Fri, Mar 21, 2014 at 2:08 PM, Arvind Kumar <arvindkumar@vmware.com> wrote:
> > The driver is missing calls to pci_dma_mapping_error() after
> > performing the DMA mapping, which caused DMA-API warning to
> > show up in dmesg's output. Though that happens only when
> > DMA_API_DEBUG option is enabled. This change fixes the issue
> > and makes pvscsi_map_buffers() function more robust.
> >
> > Signed-off-by: Arvind Kumar <arvindkumar@vmware.com>
> > Cc: Josh Boyer <jwboyer@fedoraproject.org>
> 
> This patch has been sent and pinged for 3 months now.  It's gotten no
> comments at all.  Should we send it to Linus so it actually gets
> picked up?

It's waiting for someone to review it.  If you're interested in it, have
you reviewed it?  In which case just add your reviewed by and we're
ready to go.

James


