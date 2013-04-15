From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/1] scsi: Handle MLQUEUE busy response in
 scsi_send_eh_cmnd
Date: Mon, 15 Apr 2013 13:45:30 -0700
Message-ID: <1366058730.7609.8.camel@dabdike>
References: <20130415183949.678757952@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55213 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440Ab3DOUpd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Apr 2013 16:45:33 -0400
In-Reply-To: <20130415183949.678757952@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

On Mon, 2013-04-15 at 13:39 -0500, wenxiong@linux.vnet.ibm.com wrote:
> In scsi_send_eh_cmnd(), this fix will check the return code of queuecomamnd
> when sending commands and retry for a bit if the driver returns a
> busy response.

This is already handled by the timeout, I think.  If a driver
continuously returns MLQUEUE BUSY, then we'll fail the request after the
timeout on the command expires.

James


