From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 02/15] libata: Add some dummy noop functions
Date: Tue, 21 Mar 2006 21:03:53 -0500
Message-ID: <4420B089.5030403@pobox.com>
References: <200603172304.k2HN49hr018969@d03av01.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:6844 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751335AbWCVCDz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Mar 2006 21:03:55 -0500
In-Reply-To: <200603172304.k2HN49hr018969@d03av01.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Brian King wrote:
> Add some dummy noop functions for use by libata clients
> that do not need to do anything. Future SAS patches will
> utilize these functions.
> 
> Signed-off-by: Brian King <brking@us.ibm.com>

applied 2-3


