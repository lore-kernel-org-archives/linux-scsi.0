From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [RFC PATCH 1/2] lpfc: add target infrastructure
Date: Thu, 18 Jun 2015 00:28:13 +0200
Message-ID: <20150618002813.000038a7@localhost>
References: <20150614172045.0000184d@localhost>
	<558126FC.9030207@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62069 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933008AbbFQW2s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jun 2015 18:28:48 -0400
In-Reply-To: <558126FC.9030207@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, James Smart <james.smart@avagotech.com>, Sebastian Herbszt <herbszt@gmx.de>

Hannes Reinecke wrote:
> On 06/14/2015 05:20 PM, Sebastian Herbszt wrote:
> > Add target infrastructure.
> > 
> > Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
> > ---
> Hmm. And that hooks into _which_ target mode infrastructure?

Currently it is SCST with the lpfc_scst module. I still need to figure out
how to plug it into LIO/TCM.
 
> Cheers,
> 
> Hannes

Sebastian
