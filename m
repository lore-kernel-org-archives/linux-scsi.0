From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/21] m68k/scsi: a2091 - Kill ugly DMA() macro
Date: Mon, 5 Apr 2010 02:25:29 -0400
Message-ID: <20100405062529.GA28950@infradead.org>
References: <1270371651-2584-2-git-send-email-geert@linux-m68k.org> <1270371651-2584-3-git-send-email-geert@linux-m68k.org> <1270371651-2584-4-git-send-email-geert@linux-m68k.org> <1270371651-2584-5-git-send-email-geert@linux-m68k.org> <1270371651-2584-6-git-send-email-geert@linux-m68k.org> <1270371651-2584-7-git-send-email-geert@linux-m68k.org> <1270371651-2584-8-git-send-email-geert@linux-m68k.org> <1270371651-2584-9-git-send-email-geert@linux-m68k.org> <1270371651-2584-10-git-send-email-geert@linux-m68k.org> <1270371651-2584-11-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45360 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0DEGZk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2010 02:25:40 -0400
Content-Disposition: inline
In-Reply-To: <1270371651-2584-11-git-send-email-geert@linux-m68k.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org

Instead of abusing the ScsiHost base field I'd prefer if you stick
a properly typed pointer into the device specific host data.

