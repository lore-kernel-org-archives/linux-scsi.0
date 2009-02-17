From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2 2/6 2.6.29-rc] cxgb3i - added per-task data to track
 transmit progress
Date: Tue, 17 Feb 2009 15:15:35 -0600
Message-ID: <499B28F7.9080005@cs.wisc.edu>
References: <200902140538.n1E5cnWQ014331@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53815 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbZBQVPp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 16:15:45 -0500
In-Reply-To: <200902140538.n1E5cnWQ014331@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Karen Xie wrote:
> [PATCH v2 2/6 2.6.29-rc] cxgb3i - added per-task data to track transmit progress
> 
> From: Karen Xie <kxie@chelsio.com>
> 
> added per-task struct cxgb3i_task_data to track the data transmiting
> progress and the state of the pdus to be transmitted.
> 
> Signed-off-by: Karen Xie <kxie@chelsio.com>

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
