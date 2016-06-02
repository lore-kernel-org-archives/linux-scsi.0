From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Performance degradation on 4.6
Date: Thu, 2 Jun 2016 04:37:12 -0700
Message-ID: <20160602113712.GA24605@infradead.org>
References: <CAANLjFp28MkaMjWKwXnMGHPCX2S_g_RKOhXqHc9dYVJvMgqvVw@mail.gmail.com>
 <1464814819.10899.3.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50685 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbcFBLhO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2016 07:37:14 -0400
Content-Disposition: inline
In-Reply-To: <1464814819.10899.3.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Robert LeBlanc <robert@leblancnet.us>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>

On Wed, Jun 01, 2016 at 02:00:19PM -0700, Nicholas A. Bellinger wrote:
> Hi Robert,
> 
> Adding HCH + Sagi CC, as there have been significant changes made in
> RDMA for v4.6 code.

And 4.5 for that matter.  It would be really useful to figure out
if it's the target or the initiator that regressed, and weather it's in
4.5 or 4.6.
