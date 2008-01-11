From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/10] lpfc 8.2.4 : Make lpfc legacy I/O port free
Date: Fri, 11 Jan 2008 11:52:03 -0600
Message-ID: <1200073924.3286.40.camel@localhost.localdomain>
References: <1200034380.27954.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46688 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761489AbYAKRwI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 12:52:08 -0500
In-Reply-To: <1200034380.27954.23.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Fri, 2008-01-11 at 01:53 -0500, James Smart wrote:
> Make lpfc legacy I/O port free
> 
> This is a patch written by Tomohiro Kusumi and submitted to
> linux-scsi:
> 
> http://marc.info/?l=linux-scsi&m=118673720712152&w=2
> 
> The original patch comment:
> 
> This patch makes Emulex lpfc driver legacy I/O port free.
> It has already been acked quite long time ago.
> So I resubmit the patch.
> http://lkml.org/lkml/2006/11/22/28
> 
> Current lpfc driver is already using pci_select_bars()
> and pci_enable_device_bars() when the PCI bus has been reset.
> So I think this patch should also be acked.
> 
> Tomohiro Kusumi
> 
> Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
> Signed-off-by: James Smart <James.Smart@emulex.com>

You didn't check the diffstat of this one:

 lpfc_init.c      |   11 
 lpfc_init.c.orig | 2475 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 2481 insertions(+), 5 deletions(-)

I've manually removed all references to the lpfc_init.c.orig file that
popped into existence with this patch and was deleted with the
subsequent one.

James


