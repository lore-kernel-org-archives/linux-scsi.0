From: Jamie Clark <jamie@zeroth.org>
Subject: Re: qla2xxx driver/firmware versions & thermal stability
Date: Tue, 17 Aug 2004 07:41:27 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41214627.8020408@zeroth.org>
References: <41206B59.5070703@zeroth.org> <20040816211943.GA16524@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moof.zeroth.org ([203.117.131.35]:5386 "EHLO moof.zeroth.org")
	by vger.kernel.org with ESMTP id S266469AbUHPXlp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 19:41:45 -0400
In-Reply-To: <20040816211943.GA16524@praka.san.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@pobox.com>
Cc: linux-scsi@vger.kernel.org

Andrew Vasquez wrote:

>Could you report your findings to QLogic tech-support
>(www.qlogic.com/support), they'll be able to assist in
>troubleshooting.  
>
>  
>
:) Been there recently. In a nutshell: "it shouldn't happen,
but that's quite an old driver, perhaps you could try
upgrading"

Forgive me for not taking the advice immediately, but if
you knew how long I'd been looking at this, how much
equipment isolated/replaced and how many versions
of the qla driver I build/tried *before* 6.04...

When my colleague raised this on lkml 12-18months
ago (before we knew it was heat related) he had an
off-list reply from someone who had spent a long
time chasing the same error - and traced it to heat
sensitivity (within operating spec).

I originially concluded that it was perhaps a bad batch
of cards - hence replacing all the 2300s with 2340s.

I may eventually replace the driver as I have almost
run out of options - but I was hoping for something
a little more scientific after my past driver upgrades.
