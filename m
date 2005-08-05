From: Olaf Hering <olh@suse.de>
Subject: Re: [PATCH] uninline exported ata_host_intr
Date: Fri, 5 Aug 2005 19:39:18 +0200
Message-ID: <20050805173918.GA6333@suse.de>
References: <20050805170349.GA6065@suse.de> <42F39DA0.5000208@pobox.com> <20050805171500.GA6161@suse.de> <20050805173003.GU13374@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:47544 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S262844AbVHERjY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2005 13:39:24 -0400
Content-Disposition: inline
In-Reply-To: <20050805173003.GU13374@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

 On Fri, Aug 05, Andrew Vasquez wrote:

> Confused, you found a reference to ata_host_intr() in qla4xxx
> (QLogic's iSCSI driver)?  This is in a SLES kernel correct, and not in
> mainline?

No, qla4xxx called extern inline function in foo.c from bar.c. gcc4 doesnt like
that because the 'function body is not available'. I found no external users of
ata_host_intr, maybe it happens there as well.
If there is a significant performance boost with these inline constructs,
thats just fine with me as long as it compiles.
