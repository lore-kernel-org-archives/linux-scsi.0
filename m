From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [dm-devel] Re: fibre channel/multipath questions
Date: Tue, 30 Aug 2005 07:01:48 +0200
Message-ID: <1125378108.6375.15.camel@zezette>
References: <200508261812.23328.Rik.Bobbaers@cc.kuleuven.be>
	 <20050829172316.GC7875@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp11.wanadoo.fr ([193.252.22.31]:52185 "EHLO
	smtp11.wanadoo.fr") by vger.kernel.org with ESMTP id S932141AbVH3FBs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 01:01:48 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf1103.wanadoo.fr (SMTP Server) with ESMTP id 82C371C000B8
	for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2005 07:01:47 +0200 (CEST)
In-Reply-To: <20050829172316.GC7875@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Rik Bobbaers <Rik.Bobbaers@cc.kuleuven.be>, linux-scsi@vger.kernel.org

On lun, 2005-08-29 at 18:23 +0100, Christoph Hellwig wrote:
> I think you can setup dm-multipath based on WWNs, so the device
> numbers don't matter.  Cc'ed the dm-devel list to verify my assumption.
> 
Yes, true for the multipathed devices, which leaves the problem intact
for the local drives ...
-- 
christophe varoqui <christophe.varoqui@free.fr>


