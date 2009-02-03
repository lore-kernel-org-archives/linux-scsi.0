From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH mm/next] libfc: uses/select CRC32
Date: Tue, 3 Feb 2009 19:21:10 +0100
Message-ID: <20090203182110.GA24821@elte.hu>
References: <200901052050.n05Kox9j012519@imap1.linux-foundation.org> <4962A04F.5020404@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:46841 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbZBCSV3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Feb 2009 13:21:29 -0500
Content-Disposition: inline
In-Reply-To: <4962A04F.5020404@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>, jejb <James.Bottomley@steeleye.com>, scsi <linux-scsi@vger.kernel.org>


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> libfc uses crc32 functions, so cause it to be built
> via select:
> 
> drivers/built-in.o: In function `fc_frame_crc_check':
> (.text+0x75dae): undefined reference to `crc32_le'
> drivers/built-in.o: In function `fc_fcp_recv':
> fc_fcp.c:(.text+0x7b919): undefined reference to `crc32_le'
> fc_fcp.c:(.text+0x7b9d5): undefined reference to `crc32_le'
> fc_fcp.c:(.text+0x7ba54): undefined reference to `crc32_le'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Hm, is there a reason why this fix has not gone upstream? I'm still 
stumbling across it in build tests with a latest -git base.

	Ingo
