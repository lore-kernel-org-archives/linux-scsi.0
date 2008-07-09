From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
Date: Wed, 09 Jul 2008 17:42:37 +0100
Message-ID: <7286.1215621757@redhat.com>
References: <20080709164929.799e4e05@the-village.bc.nu> <E1KGa1W-0004nG-Cw@n2o.xs4all.nl> <20080709113547.19235.15424.stgit@warthog.procyon.org.uk> <4561.1215612914@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbYGIQm6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2008 12:42:58 -0400
In-Reply-To: <20080709164929.799e4e05@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, Miquel van Smoorenburg <miquels@cistron.nl>, akpm@linux-foundation.org, alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Agreed - stick | GFP_DMA32 on the end then ;)

Ummm... Does that actually work on kmalloc()?  Or only on alloc_pages()?

David
