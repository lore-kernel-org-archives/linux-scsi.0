From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Fw: ACARD SCSI driver update for Linux kernel v2.6
Date: Thu, 06 Jan 2005 23:10:58 +0000
Message-ID: <1105052325.17166.284.camel@localhost.localdomain>
References: <026801c4ee56$1e802810$6200a8c0@jameshsu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:51388 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S261643AbVAGAPb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2005 19:15:31 -0500
In-Reply-To: <026801c4ee56$1e802810$6200a8c0@jameshsu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jameshsu <jameshsu@mail.acard.com>
Cc: linux-scsi@vger.kernel.org

The trouble with the patch as is, is that it mixes up

- Reversals of improvements like hotplug pci made outside Acard
- Addition of support for the AEC67160
- Other unknown improvements Acard may have made

In order for this to be useful we need to be able to see just the
changes that are important.

I can easily see for example the new PCI identifiers but not the other
needed changes. In order to do that I really need either a description
of the relevant changes or those changes versus the existing 2.6 driver
tree.

Any help welcomed.

Alan

