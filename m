From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi/sym53c8xx: Fix a warning in sym_eh_handler
Date: Wed, 24 Oct 2007 05:25:43 -0600
Message-ID: <20071024112543.GX27248@parisc-linux.org>
References: <20071024115920.6728832c@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39836 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbXJXLZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2007 07:25:44 -0400
Content-Disposition: inline
In-Reply-To: <20071024115920.6728832c@hyperion.delvare>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 24, 2007 at 11:59:20AM +0200, Jean Delvare wrote:
> In 2.6.24-rc1 I see the following warning:
> drivers/scsi/sym53c8xx_2/sym_glue.c: In function "sym_eh_handler":
> drivers/scsi/sym53c8xx_2/sym_glue.c:612: warning: "io_reset" may be used uninitialized in this function
> 
> Although gcc is wrong and the code is actually correct, it can easily
> be made more obvious to keep the compiler quiet.

Which compiler version?  I don't see this with 4.2.1.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
