From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Iscsitarget-devel] Re: [ANNOUNCE] iSCSI enterprise
	target	software
Date: Tue, 01 Mar 2005 11:51:45 +0100
Message-ID: <1109674305.6293.83.camel@laptopd505.fenrus.org>
References: <1109666441.6293.62.camel@laptopd505.fenrus.org>
	 <20050301183549J.fujita.tomonori@lab.ntt.co.jp>
	 <1109670363.6293.70.camel@laptopd505.fenrus.org>
	 <20050301192257C.fujita.tomonori@lab.ntt.co.jp>
	 <1109673220.6293.78.camel@laptopd505.fenrus.org>
	 <42244876.9000204@terra.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:649 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261862AbVCAKvv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 05:51:51 -0500
In-Reply-To: <42244876.9000204@terra.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Libor Vanek <lvanek@terra.cz>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net

On Tue, 2005-03-01 at 11:48 +0100, Libor Vanek wrote:
> >
> I don't know in detail what are you talking about (if whole disk must 
> fit address space) but please consider we're speaking about TBs (10-20 
> TB RAID is quite cheap nowadays with 400 GB SATA disks).

so? if you need one map/unmap per terabyte, the cost of that is like
zero.


