From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: InitIO SCSI: Volunteers required
Date: Fri, 20 Apr 2007 10:38:49 +0100
Message-ID: <20070420103849.7358f1f1@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41300 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992773AbXDTJfS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Apr 2007 05:35:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I'm looking for some testers for a revamp of the initio driver. No real
code changes other than to hopefully stop it exploding on load on 64bit,
but a major reorganisation, commenting and "de-windowsification" so the
code is actually readable and I can do the pci_find_device to
pci_get_device transitions.

Alan
