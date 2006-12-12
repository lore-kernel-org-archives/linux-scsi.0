From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2] cciss: remove calls to pci_disable_device
Date: Tue, 12 Dec 2006 23:12:37 +0000
Message-ID: <20061212231237.59581b28@localhost.localdomain>
References: <20061212195458.GB2471@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44441 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964788AbWLLXGz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Dec 2006 18:06:55 -0500
In-Reply-To: <20061212195458.GB2471@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mike.miller@hp.com
Cc: mikem@beardog.cca.cpqcorp.net, akpm@osdl.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 12 Dec 2006 13:54:58 -0600
"Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:

> PATCH 2/2
> 
> This patch removes calls to pci_disable_device except in fail_all_cmds. The pci_disable_device function does something nasty to Smart Array controllers that pci_enable_device does not undo. So if the driver is unloaded it cannot be reloaded.

Acked-by: Alan Cox <alan@redhat.com>

Various devices do this. Please however update the patch or add a patch
which includes comments as to why or someone will helpfully put them back
one day.
