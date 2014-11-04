From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [V2 PATCH 2/2] scsi: TUR path is down after adapter gets reset
 with multipath
Date: Tue, 4 Nov 2014 07:01:52 -0800
Message-ID: <20141104150152.GA17309@infradead.org>
References: <20141103211806.572351346@linux.vnet.ibm.com>
 <20141103211815.000777763@linux.vnet.ibm.com>
 <54587E69.50108@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54119 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbaKDPBz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 10:01:55 -0500
Content-Disposition: inline
In-Reply-To: <54587E69.50108@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: wenxiong@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

On Tue, Nov 04, 2014 at 08:21:13AM +0100, Hannes Reinecke wrote:
> Why did you use a wrapper for an already existing function?
> Please fold the logic into alua_check_sense().

That's what the first version did.  See the response from Rob to it
on why it's done this way.
