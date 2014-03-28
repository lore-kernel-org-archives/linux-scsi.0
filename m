From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH] Block/iopoll: Remove redundant export variable blk_iopoll_enabled
Date: Fri, 28 Mar 2014 14:05:56 -0600
Message-ID: <5335D624.9040001@fb.com>
References: <1396036889-10794-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8904 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751435AbaC1UGH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2014 16:06:07 -0400
In-Reply-To: <1396036889-10794-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Brian King <brking@us.ibm.com>

On 03/28/2014 02:01 PM, Sagi Grimberg wrote:
> No need for this variable anymore - blk_iopoll should always
> be enabled. Also remove the user references to it.
>
> I just removed the blk_iopoll_enabled condition from the user logic
> but I don't have the facilities to test that I didn't break be2iscsi
> or ipr users, So I was hoping that Jayamohan & Wen can confirm.
>
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> Cc: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> Cc: Brian King <brking@us.ibm.com>

This is sitting in my for-3.15/core branch since about two weeks ago:

http://git.kernel.dk/?p=linux-block.git;a=commit;h=89f8b33ca1ea881d1d84542282cb85d07d02e78d

-- 
Jens Axboe

