From: Andrew Morton <akpm@osdl.org>
Subject: Re: [patch] 2.6.9-rc1-mm1: megaraid_mbox.c compile error with gcc
 3.4
Date: Mon, 30 Aug 2004 12:55:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040830125509.46ea399c.akpm@osdl.org>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC9C6@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:65495 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S268907AbUH3T50 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 15:57:26 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC9C6@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: bunk@fs.tum.de, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

"Mukker, Atul" <Atulm@lsil.com> wrote:
>
> 2.	The guideline on the size of patches. Because of the new driver, the
>  size of the patches for megaraid are relatively big (the small patches are
>  always inlined). Should it be discretionary for submitter to either inline,
>  attach, or (deprecated) send a link, based on size of the package.

Sending a URL to a big patch is a necessary evil for mailing lists, so the
best approach would be to also mail the patches directly to the guy(s) who
you wish to apply them.

An even better approach is to split the patches up so they are not so big ;)

Following the "once concept per patch rule" works well.
