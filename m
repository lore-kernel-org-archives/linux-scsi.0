From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sd varyio fix
Date: Sun, 28 Jul 2002 19:28:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020728192845.A15209@infradead.org>
References: <20020715221604.GA10274@nbkurt.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020715221604.GA10274@nbkurt.etpnet.phys.tue.nl>; from garloff@suse.de on Tue, Jul 16, 2002 at 12:16:04AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Marcelo Tosatti <marcelo@conectiva.com.br>, Linux SCSI list <linux-scsi@vger.kernel.org>, Dave Jones <davej@suse.de>

On Tue, Jul 16, 2002 at 12:16:04AM +0200, Kurt Garloff wrote:
> Hi Marcelo,
> 
> another one: The bit shift for vary io in the sd driver was wrong.
> I don't know whether it has much impact, but it should be fixed anyway.
> 
> Patch against 2.4.19rc1 attached.

This patch is not against 2.4.19rc1..  (I guess some SuSE tree?)

