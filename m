From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fw: ACARD SCSI driver update for Linux kernel v2.6
Date: Fri, 7 Jan 2005 10:11:44 +0000
Message-ID: <20050107101144.GA6094@infradead.org>
References: <026801c4ee56$1e802810$6200a8c0@jameshsu> <1105052325.17166.284.camel@localhost.localdomain> <035001c4f4a0$6b3b4e50$6200a8c0@jameshsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:23482 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261339AbVAGKLs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2005 05:11:48 -0500
Content-Disposition: inline
In-Reply-To: <035001c4f4a0$6b3b4e50$6200a8c0@jameshsu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jameshsu <jameshsu@mail.acard.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, EdwardLian <edwardlian@mail.acard.com>, Jason Wu <jason_wu@acard.com>

> New driver will be submit around 1-2 week later.
> During these period, if you have more suggestions, please let us know ASAP
> while testing.

In general life for us and you is easier if you submit changes as you
make them in small chunks.  E.g. submit the new PCI ID asap, submit
small fixes you think are needed in the driver ASAP, etc..

Small patches are much easier review, and and you get obviously correct
pieces out ASAP.

