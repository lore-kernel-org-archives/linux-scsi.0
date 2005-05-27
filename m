From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH] allow sleep inside EH hooks
Date: Fri, 27 May 2005 08:40:03 +0200
Message-ID: <1117176003.6293.6.camel@laptopd505.fenrus.org>
References: <4296A2C7.4090107@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:20702 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261877AbVE0Gkc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 02:40:32 -0400
In-Reply-To: <4296A2C7.4090107@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-05-27 at 00:32 -0400, Jeff Garzik wrote:
> SCSI EH processing already serializes things during EH, so this spinlock 
> isn't really needed.
> 
> Removing the spinlock outright would break drivers that surround logic 
> with spin_unlock_irq()..spin_lock_irq(), so I introduced ->unlocked_eh 
> option.

it's not THAT many drivers that do that, and relatively easy to grep
for... so why not just remove those unlock ... lock pairs instead?


