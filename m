From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mpt fusion - add support for fibre channel FC949ES
Date: Fri, 13 Jan 2006 18:10:49 +0000
Message-ID: <20060113181049.GH20718@infradead.org>
References: <43C6DE45.7040609@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42115 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1422781AbWAMSKu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 13:10:50 -0500
Content-Disposition: inline
In-Reply-To: <43C6DE45.7040609@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric Dean" <Eric.Moore@lsil.com>

On Thu, Jan 12, 2006 at 04:55:01PM -0600, Michael Reed wrote:
> Add software recognition for the new LSI Logic Fibre Channel controller.
> (Patch originally sent to me by Eric Moore.)

don't you need to add it to the pci_ids table aswell?

also include the previous patch to add the #define to pci_ids.h to this
patch as akpm apparently doesn't lie that one on it's own.
