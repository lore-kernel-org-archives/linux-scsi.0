From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: Further aacraid work
Date: 18 Jun 2004 09:07:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087567647.1752.2.camel@mulgrave>
References: <286GI-5y3-11@gated-at.bofh.it> <286Qp-5EU-19@gated-at.bofh.it>
	<m3smcut2z0.fsf@averell.firstfloor.org>
	<20040617205414.GE8705@devserv.devel.redhat.com>
	<40D2842F.6090304@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:3233 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265154AbUFROKM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2004 10:10:12 -0400
In-Reply-To: <40D2842F.6090304@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Alan Cox <alan@redhat.com>, Andi Kleen <ak@muc.de>, Anton Blanchard <anton@samba.org>, mark_salyzyn@adaptec.com, Christoph Hellwig <hch@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>

On Fri, 2004-06-18 at 00:57, Jeff Garzik wrote:
> James and BenH discussed a solution at the DMA level, but I don't think 
> anything ever happened.

Actually, yes it did.  I have the patches but they depend on another bio
change which is still making its way through the process.

James


