From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 19/20] qla2xxx: Fix multiqueue MSI-X registration.
Date: Mon, 16 Dec 2013 07:47:54 +0100
Message-ID: <52AEA21A.90007@acm.org>
References: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com> <1386965040-20611-20-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.66]:43410 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3LPGr7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 01:47:59 -0500
In-Reply-To: <1386965040-20611-20-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>, jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On 12/13/13 21:03, Saurav Kashyap wrote:
> From: Chad Dupuis <chad.dupuis@qlogic.com>
> 
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>

Shouldn't this patch be CC-ed to stable with a more elaborate commit
message ? It has not been mentioned what has been fixed nor for which
kernel versions this fix avoids a kernel oops.

Bart.

