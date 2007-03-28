From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] [qla2xxx] Remove duplicate pci_disable_device() call
Date: Wed, 28 Mar 2007 08:41:31 -0700
Message-ID: <20070328154131.GA24606@andrew-vasquezs-computer.local>
References: <20070327224949.GB17095@strauss.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:38353 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbXC1Plh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Mar 2007 11:41:37 -0400
Content-Disposition: inline
In-Reply-To: <20070327224949.GB17095@strauss.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bernhard Walle <bwalle@suse.de>

On Wed, 28 Mar 2007, Bernhard Walle wrote:

> [PATCH] [qla2xxx] Remove duplicate pci_disable_device() call
> 
> On the path qla2x00_probe_one() -> probe_failed -> qla2x00_free_device(),
> pci_disable_device() is executed twice, once in qla2x00_free_device()
> and once in qla2x00_probe_one().
> 
> This patch removes the unnecessary call.
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>

Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
