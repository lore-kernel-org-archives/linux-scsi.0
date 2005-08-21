From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 2.6.12.5 1/2] lib: allow idr to be used in irq context
Date: Sun, 21 Aug 2005 01:25:06 -0700
Message-ID: <20050821012506.5b106dab.akpm@osdl.org>
References: <430262C5.20503@adaptec.com>
	<1124294489.2802.107.camel@new.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750711AbVHUI0u@vger.kernel.org>
In-Reply-To: <1124294489.2802.107.camel@new.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Jim Houston <jim.houston@ccur.com>
Cc: luben_tuikov@adaptec.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davej@redhat.com, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

Jim Houston <jim.houston@ccur.com> wrote:
>
> On Tue, 2005-08-16 at 18:03, Luben Tuikov wrote:
> 
> > If idr_get_new() or idr_remove() is used in IRQ context,
> > then we may get a lockup when idr_pre_get was called
> > in process context and an IRQ interrupted while it held
> > the idp lock.
> 
> Hi Everyone,
> 
> Luben's changes make sense please merge them.
> 

Well yes, the change makes sense if there's actually a caller which needs it.

If there is such a caller then Luben should identify it, please.
