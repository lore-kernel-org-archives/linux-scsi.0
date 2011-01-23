From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] target: Call proc_mkdir + remove_proc_entry with NULL
 parameter
Date: Sun, 23 Jan 2011 08:12:51 -0600
Message-ID: <1295791971.3007.0.camel@mulgrave.site>
References: <1295738425-4814-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56631 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab1AWOM5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Jan 2011 09:12:57 -0500
In-Reply-To: <1295738425-4814-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Fubo Chen <fubo.chen@gmail.com>, Christoph Hellwig <hch@lst.de>

On Sat, 2011-01-22 at 15:20 -0800, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch makes proc_mkdir() and remove_proc_entry() use a NULL
> parameter to fix the following sparse warning:
> 
> CHECK   drivers/target/target_core_configfs.c
> drivers/target/target_core_configfs.c:3131:54: warning: Using plain integer as NULL pointer
> drivers/target/target_core_configfs.c:3145:50: warning: Using plain integer as NULL pointer
> drivers/target/target_core_configfs.c:3212:42: warning: Using plain integer as NULL pointer

Um, so I thought this interface was being replaced ... there's not a lot
of point in sparse fixing it.

James


