From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 11/17] sym53c8xx: Remove tag_ctrl module parameter
Date: Fri, 05 Oct 2007 16:56:41 -0400
Message-ID: <4706A509.4070608@garzik.org>
References: <11916141143747-git-send-email-matthew@wil.cx> <11916141152123-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:35545 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761972AbXJEU4n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Oct 2007 16:56:43 -0400
In-Reply-To: <11916141152123-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> With sysfs making these options tunable at runtime, there's no
> justification for keeping this horrendously complex specification
> string around.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  Documentation/scsi/sym53c8xx_2.txt   |   21 +++--------
>  drivers/scsi/sym53c8xx_2/sym53c8xx.h |    1 -
>  drivers/scsi/sym53c8xx_2/sym_glue.c  |   66 ++--------------------------------
>  3 files changed, 8 insertions(+), 80 deletions(-)

ACK presuming you are convinced this will not break anybody in the field


