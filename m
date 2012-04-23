From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] fc class: fix scanning when devs are offline
Date: Mon, 23 Apr 2012 16:26:22 -0500
Message-ID: <4F95C8FE.70001@cs.wisc.edu>
References: <1334544470-2300-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40876 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab2DWV0U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Apr 2012 17:26:20 -0400
In-Reply-To: <1334544470-2300-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On 04/15/2012 09:47 PM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> When a rport is added back or the role is changed the fc class
> will queue a scan and then call scsi_target_unblock. The problem
> with this is if the devices are in the SDEV_OFFLINE state and
> the scan is run before the scsi_target_unblock, then the scan
> will see LUN0 as offline and the scan will fail. This patch moves
> the unblock call to before the scan, so we know the device state
> will be set correctly when the scan is run.

I forgot to add my signed off for the patch.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
