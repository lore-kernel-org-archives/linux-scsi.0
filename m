From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 3/3] ahci_xgene: Fix the link down in first attempt
 for the APM X-Gene SoC AHCI SATA host controller driver.
Date: Tue, 26 Aug 2014 11:29:48 -0400
Message-ID: <20140826152948.GC29286@htj.dyndns.org>
References: <1408819047-17224-1-git-send-email-stripathi@apm.com>
 <1408819047-17224-4-git-send-email-stripathi@apm.com>
 <20140825193002.GC21688@htj.dyndns.org>
 <CAOHikRDpLBAnH4pmFzfu_RXFUZNAWPc-Q34zS1_Mx-odOmXonA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:39386 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934446AbaHZP3w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Aug 2014 11:29:52 -0400
Content-Disposition: inline
In-Reply-To: <CAOHikRDpLBAnH4pmFzfu_RXFUZNAWPc-Q34zS1_Mx-odOmXonA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, patches@apm.com

On Tue, Aug 26, 2014 at 12:17:35PM +0530, Suman Tripathi wrote:
> Didn't I ask you to update the comment to explain what's going on?
> [suman] : can you specifically tell which part of the comment is not clear
> and need more explanation?

The comment on top of the function doesn't seem to match what's being
implemented.  In addition, it's generally not very useful to list the
actual algorithm in text.  Put algorithm in code and explain the
summary and rationales for it in the comments.  Nothing explains why
the retries are being done.

> is the existing comment already sufficient?
> [suman] : The existing comment is sufficient .

No, this isn't.  You don't have to include a novel to explain it but
there's something different going on here and you should provide
information on why this sort of deviation is necessary.

-- 
tejun
