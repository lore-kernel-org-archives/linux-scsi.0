From: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] scsi/sym53c8xx: Fix a warning in sym_eh_handler
Date: Wed, 24 Oct 2007 14:46:16 +0200
Message-ID: <20071024144616.47564401@hyperion.delvare>
References: <20071024115920.6728832c@hyperion.delvare>
	<20071024112543.GX27248@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:54849 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758389AbXJXMqS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2007 08:46:18 -0400
In-Reply-To: <20071024112543.GX27248@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Wed, 24 Oct 2007 05:25:43 -0600, Matthew Wilcox wrote:
> On Wed, Oct 24, 2007 at 11:59:20AM +0200, Jean Delvare wrote:
> > In 2.6.24-rc1 I see the following warning:
> > drivers/scsi/sym53c8xx_2/sym_glue.c: In function "sym_eh_handler":
> > drivers/scsi/sym53c8xx_2/sym_glue.c:612: warning: "io_reset" may be used uninitialized in this function
> > 
> > Although gcc is wrong and the code is actually correct, it can easily
> > be made more obvious to keep the compiler quiet.
> 
> Which compiler version?  I don't see this with 4.2.1.

gcc version 4.1.2.

-- 
Jean Delvare
