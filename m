From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [SCSI] hpsa: Fix driver support flag initialisation on
 !x86
Date: Sun, 20 Jul 2014 17:42:02 -0700
Message-ID: <20140721004202.GA29358@infradead.org>
References: <1405901357.8631.24.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49192 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaGUAmL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Jul 2014 20:42:11 -0400
Content-Disposition: inline
In-Reply-To: <1405901357.8631.24.camel@deadeye.wl.decadent.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Jul 21, 2014 at 01:09:17AM +0100, Ben Hutchings wrote:
> On !x86 we currently don't read the existing support flags:

Arnd already sent this and I've included it in the for-3.17 queue.

