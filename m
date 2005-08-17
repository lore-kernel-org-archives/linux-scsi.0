From: Jim Houston <jim.houston@ccur.com>
Subject: Re: [PATCH 2.6.12.5 1/2] lib: allow idr to be used in irq context
Date: 17 Aug 2005 12:01:29 -0400
Message-ID: <1124294489.2802.107.camel@new.localdomain>
References: <430262C5.20503@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751155AbVHQQBd@vger.kernel.org>
In-Reply-To: <430262C5.20503@adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Dave Jones <davej@redhat.com>, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2005-08-16 at 18:03, Luben Tuikov wrote:

> If idr_get_new() or idr_remove() is used in IRQ context,
> then we may get a lockup when idr_pre_get was called
> in process context and an IRQ interrupted while it held
> the idp lock.

Hi Everyone,

Luben's changes make sense please merge them.

Jim Houston - Concurrent Computer Corp.
