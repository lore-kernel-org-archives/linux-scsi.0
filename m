From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/2] RFC: The be2iscsi driver support for bsg
Date: Tue, 23 Mar 2010 21:35:42 +0900
Message-ID: <20100323213504F.fujita.tomonori@lab.ntt.co.jp>
References: <4BA3747E.4020104@emulex.com>
	<20100322175704Y.fujita.tomonori@lab.ntt.co.jp>
	<4BA789CF.3040100@emulex.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:45661 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab0CWMgH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2010 08:36:07 -0400
In-Reply-To: <4BA789CF.3040100@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, jayamohank@serverengines.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, open-iscsi@googlegroups.com

On Mon, 22 Mar 2010 11:16:31 -0400
James Smart <james.smart@emulex.com> wrote:

> > About the implementation, I think that it's better to have the common
> > library code rather than just copying the fs bsg code into iscsi.
> 
> Note: I tried to library-ize the transport implementation on the first pass of 
> the RFC. But it was making things more complex.  I tried to explain this, 
> perhaps not very well (http://marc.info/?l=linux-scsi&m=125725904205688&w=2).

Ah, I overlooked it. I'll think about it later. Maybe Mike already has
some ideas about it. Anyway, library-izing is not urgent at all. We
can work on it later.
