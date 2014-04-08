From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: lpfc: lpfc_init: use kcalloc for allocating memory
Date: Tue, 08 Apr 2014 13:20:42 -0700
Message-ID: <1396988442.14321.0.camel@joe-AO722>
References: <1396988297-29240-1-git-send-email-eu@opreamatei.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0090.hostedemail.com ([216.40.44.90]:36504 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756036AbaDHUUq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Apr 2014 16:20:46 -0400
In-Reply-To: <1396988297-29240-1-git-send-email-eu@opreamatei.ro>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matei Oprea <eu@opreamatei.ro>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ROSEdu Kernel Community <firefly@lists.rosedu.org>

On Tue, 2014-04-08 at 23:18 +0300, Matei Oprea wrote:
> It's easier to use kcalloc for allocating arrays. While at it
> also remove useless casting value.

Don't send a patch against your bad patch.
Send a new patch with just the appropriate
changes.


