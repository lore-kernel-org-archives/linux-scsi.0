From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Fw: ACARD SCSI driver update for Linux kernel v2.6
Date: Wed, 30 Mar 2005 13:45:49 +0100
Message-ID: <1112186729.14877.397.camel@localhost.localdomain>
References: <014201c5351e$70385c40$6200a8c0@jameshsu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:44982 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP id S261277AbVC3MsU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2005 07:48:20 -0500
In-Reply-To: <014201c5351e$70385c40$6200a8c0@jameshsu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jameshsu <jameshsu@mail.acard.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, EdwardLian <edwardlian@mail.acard.com>, Jason Wu <jason_wu@acard.com>, Hill Wu <hillwu@acard.com>

On Mer, 2005-03-30 at 12:48, jameshsu wrote:
> Hello Matthew/Allen,
> 
> Few weeks  pass since we sent update driver for you to build-in in Jan 2005.
> Latest,  we test Linux kernel rev 2.6.11 and found the SCSI driver not
> update yet.

It is in 2.6.12 snapshots.

> Is it possible to let us know anything Acard are still missing or any rules
> not follow??!!

It took a long time because your changes removed other fixes made over
time and it took a lot of work to merge them back together

Alan

