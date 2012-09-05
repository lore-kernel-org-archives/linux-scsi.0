From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [V2 PATCH 2/9] csiostor: Chelsio FCoE offload driver submission
 (sources part 2).
Date: Wed, 5 Sep 2012 09:29:57 -0700
Message-ID: <20120905092957.7d24187e@nehalam.linuxnetplumber.net>
References: <1346848442-4573-1-git-send-email-naresh@chelsio.com>
	<1346848442-4573-3-git-send-email-naresh@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:33161 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab2IEQaZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Sep 2012 12:30:25 -0400
In-Reply-To: <1346848442-4573-3-git-send-email-naresh@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Naresh Kumar Inna <naresh@chelsio.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, dm@chelsio.com, leedom@chelsio.com, netdev@vger.kernel.org, chethan@chelsio.com

On Wed,  5 Sep 2012 18:03:55 +0530
Naresh Kumar Inna <naresh@chelsio.com> wrote:

> This patch contains code for driver initialization, driver resource
> allocation and the Work Request module functionality. Driver initialization
> includes module entry/exit points, registration with PCI, FC transport and
> SCSI mid layer subsystems. The Work Request module provides services for
> allocation of DMA queues, posting Work Requests on them and processing
> completions.
> 
> Signed-off-by: Naresh Kumar Inna <naresh@chelsio.com>

Although the comments say you are using proc fs, there is no
code here related to that.

Any use of debugfs must be conditional the DEBUG_FS kernel configuration
parameter.  Your code probably will break if DEBUG_FS is not
enabled.  For a possible alternative see how a sub-config parameter
was added in sky2 driver.
