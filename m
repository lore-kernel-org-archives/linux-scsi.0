From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH rc8-mm1] hotfix libata-scsi corruption
Date: Tue, 22 Jan 2008 22:12:14 +0000
Message-ID: <20080122221214.1c825949@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.64.0801221706320.5832@blonde.site>
	<1201022985.3210.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1201022985.3210.24.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> However, I'd like to see if we can track the problem through the SG_IO
> direct path ... how many adjacent page bytes are corrupt?  Just a few or
> a large number (I'm wondering if it's an off by one or off by alignment
> type bug)?

Which ATA controller is involved - in theory ATA DMA is byte aligned safe
(or dword anyway) in practice I don't know if we've ever tested the non
512 byte aligned case historically for ATA just ATAPI ?

Alan
