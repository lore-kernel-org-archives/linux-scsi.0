From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Sym/LSI 53C1010-66 and 2.5.75/2.6.0-t1
Date: 14 Jul 2003 16:06:30 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058195190.561.70.camel@dhcp22.swansea.linux.org.uk>
References: <1058192382.8933.35.camel@phoenix>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:33474
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S270631AbTGNOyP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2003 10:54:15 -0400
In-Reply-To: <1058192382.8933.35.camel@phoenix>
List-Id: linux-scsi@vger.kernel.org
To: James Bromberger <jbromberger@fotango.com>
Cc: linux-scsi@vger.kernel.org

On Llu, 2003-07-14 at 15:19, James Bromberger wrote:
> Can anyone point me in the right direction to get this working please? I
> get a panic on boot since my root disk on this device, and it isn't
> being recognised during boot (ie, kernel image loads (all static kernel,
> no modules), and then panics when it tries to get to the root filesystem
> on /dev/sda3 on the disk on this controller.
> 
> I have been reading archives of this list and lkml and can't see
> anything related, but then again, I may have missed something.

First thing to check is that it has the PCI idents for your cards.
2.6test still has a lot of stale drivers so it could be something that
mundane

