From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] drivers: scsi: #define missing include guards
Date: Sun, 24 Aug 2014 08:35:15 -0700
Message-ID: <20140824153515.GB16490@infradead.org>
References: <1408711053-14129-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56263 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaHXPfR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2014 11:35:17 -0400
Content-Disposition: inline
In-Reply-To: <1408711053-14129-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 02:37:33PM +0200, Rasmus Villemoes wrote:
> The four files aha1542.h, aha1740.h, gvp11.h and mvme147.h under
> drivers/scsi/ contain two-thirds of an include guard, but do not
> elsewhere.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Looks reasonable to me, can I get a quick review for it?

