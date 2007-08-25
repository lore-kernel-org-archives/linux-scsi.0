From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] debloat aic7xxx and aic79xx drivers by deinlining
Date: Sat, 25 Aug 2007 14:57:42 -0700
Message-ID: <20070825145742.69b99168@laptopd505.fenrus.org>
References: <200708252257.07241.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51911 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbXHYWDp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Aug 2007 18:03:45 -0400
In-Reply-To: <200708252257.07241.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de

On Sat, 25 Aug 2007 22:57:07 +0100
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> Hi,
> 
> Attached patch deinlines and moves big functions from .h to .c files
> in drivers/scsi/aic7xxx/*. I also had to add prototypes for
> ahc_lookup_scb and ahd_lookup_scb to .h files.
> 

one question... how many of these can actually be static (or would be
if they were in their only-caller-c-file) ? Did you run the find static
script or are you waiting for Adrian to do that ;-)
