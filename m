From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 00/22] FCoE VN2VN fixes
Date: Thu, 4 Aug 2016 07:59:27 -0700
Message-ID: <3fbe8456-182a-d7da-068d-28866aef5314@sandisk.com>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0082.outbound.protection.outlook.com ([104.47.40.82]:59929
	"EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753274AbcHDPAc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2016 11:00:32 -0400
In-Reply-To: <1470230002-37737-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>

On 08/03/16 06:13, Hannes Reinecke wrote:
> As usual, comments and reviews are welcome.

Great work :-) Have you been testing these patches against the LIO FCoE 
target driver? In that case you might need to port the following patch 
to LIO, a patch that fixes a subtle data corruption issue: 
https://sourceforge.net/p/scst/svn/4969.

Bart.

