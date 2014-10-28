From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv8 00/27] scsi logging update (the boring part)
Date: Mon, 27 Oct 2014 22:23:53 -0400
Message-ID: <yq1bnoxort2.fsf@sermon.lab.mkp.net>
References: <1414153627-2863-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34412 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaJ1CY3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2014 22:24:29 -0400
In-Reply-To: <1414153627-2863-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Fri, 24 Oct 2014 14:26:40 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> here is now the eigth iteration of my scsi logging update.  With
Hannes> this I've updated the patch to ratelimit I/O error messages as
Hannes> suggested by Robert Elliott.  Additionally I've updated it to
Hannes> core-for-3.19 and included the missing hunks for ufs as
Hannes> requested by Christoph Hellwig.

I have read through these and nothing stuck out. Nice cleanup.

Do you have a git tree that I can use for testing?

-- 
Martin K. Petersen	Oracle Linux Engineering
