From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 RESEND 22/23] qla4xxx: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Date: Mon, 11 Aug 2014 02:40:06 -0700
Message-ID: <20140811094006.GA722@infradead.org>
References: <cover.1405533479.git.agordeev@redhat.com>
 <0496ccbc0f203afaeeb7758c146b93c2f387684c.1405533479.git.agordeev@redhat.com>
 <20140726084137.GL21129@agordeev.usersys.redhat.com>
 <3FC4AB8B47ECD546BCD4B361A64BEACD8C6CAFD2@avmb3.qlogic.org>
 <20140811085433.GL16504@dhcp-27-160.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58440 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaHKJkH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Aug 2014 05:40:07 -0400
Content-Disposition: inline
In-Reply-To: <20140811085433.GL16504@dhcp-27-160.brq.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>, Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

On Mon, Aug 11, 2014 at 10:54:34AM +0200, Alexander Gordeev wrote:
> On Mon, Jul 28, 2014 at 11:47:19AM +0000, Vikas Chaudhary wrote:
> > 
> > Acked-By: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> Christoph,
> 
> This patch seems ready..

I will apply all the patches that have gotten reviews once I open
up the queues for 3.18 which should be in about a week from now.

