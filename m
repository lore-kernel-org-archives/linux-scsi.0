From: Graham Wood <linux@dragonhold.org>
Subject: Re: [PATCH] qla1280.c patch against 2.6.9 to allow settings of Initiator ID
Date: Tue, 30 Nov 2004 10:36:04 +0000
Message-ID: <20041130103604.GA3539@dragonhold.org>
References: <20041105011830.GG8974@dragonhold.org> <yq0is7n63lw.fsf@jaguar.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ramoth.dragonhold.org ([80.229.192.20]:38024 "EHLO
	ramoth.dragonhold.org") by vger.kernel.org with ESMTP
	id S262038AbUK3KgD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 05:36:03 -0500
Content-Disposition: inline
In-Reply-To: <yq0is7n63lw.fsf@jaguar.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@wildopensource.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Nov 30, 2004 at 05:19:39AM -0500, Jes Sorensen wrote:
> What would be the reasoning for this patch? 
I've got a pair of dual 10160 controller cards that I've salvaged and don't have a PC BIOS on them - which means I've got no way to set the SCSI ID other than through the driver.  They both default to ID7, which causes a problem when I attempt to dual-attach storage.

I couldn't find any way to do that, so I patched the driver.  Since I wasn't sure if this would help other people, I thought I'd offer it as a patch.  It also seemed a simple enough change to be a good place to start, since I want to get a better understanding of the stuff I'm running as well.

> higher level rather than by the individual drivers IMHO.
Definitely - it would be better if there was a standard way to specify the SCSI ID, but since this gets set during the module initialisation, I'm not sure what sort of higher level API would make sense.

AFAIK, without unloading & reloading the driver, I don't think there's a sane way to change the ID on these cards, or indeed probably any card - since it involves a complete reset of the card (again, AFAIK).

There are similar options on a couple of the drivers, which is why I thought just adding it here would be the simplest way to do it.


Graham
