From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] qla2xxx: Drop srb reference before waiting for completion
Date: Fri, 08 Oct 2010 16:44:50 -0500
Message-ID: <4CAF90D2.2030507@cs.wisc.edu>
References: <C8D4B893.9ED0%giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50232 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab0JHVia (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Oct 2010 17:38:30 -0400
In-Reply-To: <C8D4B893.9ED0%giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, LinuxSCSI <linux-scsi@vger.kernel.org>

On 10/08/2010 02:01 PM, Giridhar Malavali wrote:
> Thanks for the clarification. I acknowledge the patch overall except for
> spin_lock changes where we need to release the lock when we return success
> or failure.

Oops, yeah sorry. You are right. Bad cut and paste.

