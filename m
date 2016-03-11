From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] sd: fix lbprz discard granularity as expected
Date: Thu, 10 Mar 2016 21:08:51 -0500
Message-ID: <yq160wtn4uk.fsf@sermon.lab.mkp.net>
References: <56e12d57.4b43620a.4c8c0.ffff9bc5@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49529 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933378AbcCKCI6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2016 21:08:58 -0500
In-Reply-To: <56e12d57.4b43620a.4c8c0.ffff9bc5@mx.google.com> (tom's message
	of "Thu, 10 Mar 2016 16:16:18 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com
Cc: linux-scsi@vger.kernel.org

>>>>> "Tom" == tom ty89 <tom.ty89@gmail.com> writes:

Tom> According to its own comment, the discard granularity should fixed
Tom> to the logical block size. However, the actual code has it
Tom> hardcoded as 1 byte. Changing it to logical_block_size.

Already fixed.

-- 
Martin K. Petersen	Oracle Linux Engineering
