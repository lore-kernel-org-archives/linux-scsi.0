From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 36/43] hpsa: add interrupt number to /proc/interrupts
 interrupt name
Date: Fri, 17 Apr 2015 15:47:00 +0200
Message-ID: <55310ED4.10902@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134958.30238.62123.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933953AbbDQNr1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:47:27 -0400
In-Reply-To: <20150416134958.30238.62123.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:49 PM, Don Brace wrote:
> From: Robert Elliott <elliott@hp.com>
>
> Add the interrupt number to the interrupt names that
> appear in /proc/interrupts, so they are unique
>
> Also, delete the IRQ and DAC prints.  Other parts of the kernel
> already print the IRQ assignments, and dual-address-cycle support
> has not been interesting since the parallel PCI bus went from
> 32 to 64 bits wide.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

