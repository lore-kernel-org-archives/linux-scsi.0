From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: hwo to adjust interrupt?
Date: Fri, 12 Aug 2005 09:14:59 +0200
Message-ID: <1123830899.3218.15.camel@laptopd505.fenrus.org>
References: <1123799468.5546.81.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:62396 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932204AbVHLHPD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 03:15:03 -0400
In-Reply-To: <1123799468.5546.81.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mingz@ele.uri.edu
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2005-08-11 at 18:31 -0400, Ming Zhang wrote:
> I have this eth1 and aic7xxx share 1 interrupt thus have impact on
> performance, anyway i can change it? thx!

realistically, either you need to find a bios setting tweak, or you need
to move one of the two to a different pci slot in the machine.


(Not that it's a big problem, sharing irqs on a pci system isn't too big
a deal)

