From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bug 3244] New: megaraid_mbox.c broken: unimplemented parts
Date: Thu, 19 Aug 2004 14:22:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040819142227.16ddf987.akpm@osdl.org>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC97E@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:24477 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S267415AbUHSVSv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 17:18:51 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC97E@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: linux-scsi@vger.kernel.org

"Mukker, Atul" <Atulm@lsil.com> wrote:
>
> Is this something specific to gcc 3.4.1.

yes,

> I do not see any such issue with
> 3.3.3 (this driver was tested on IA32, x86-64, and Itenium). Would, what
> Matt Domsch mentioned in his post on 7/27 "Re: [ANNOUNCE]: megaraid driver
> version 2.20.0.1, now 2.20.2.0" help. He talked about defining the inline
> function before they are actually used.

yes, inlining requires that the implementation appear earlier in the compilation
unit than the call site(s).
