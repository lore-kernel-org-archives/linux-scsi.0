From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/2 2.6.29-rc] libiscsi - change iscsi_session_failure()
 to take iscsi_session pointer
Date: Wed, 25 Feb 2009 10:30:42 -0600
Message-ID: <49A57232.1070203@cs.wisc.edu>
References: <200902250128.n1P1SEcp007738@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59311 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbZBYQbD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2009 11:31:03 -0500
In-Reply-To: <200902250128.n1P1SEcp007738@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Karen Xie wrote:
> [PATCH 1/2 2.6.29-rc] libiscsi - change iscsi_session_failure() to take iscsi_session pointer
> 
> From: Karen Xie <kxie@chelsio.com>
> 

I guess the From: got messed up. I am not sure if James cares or not.

James, I actually wrote the patch for Karen, and she has been using and 
testing it out with her patches so that is why/how my signed off is 
first but the "From:" above has her.


> change iscsi_session_failure() to take a pointer to iscsi_session instead of iscsi_cls_session.
> 
> Signed-off-by: Mike Christie<michaelc@cs.wisc.edu>
> Signed-off-by: Karen Xie <kxie@chelsio.com>
