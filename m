From: Shaobo <shaobo@cs.utah.edu>
Subject: Potentially invalid memory accesses drivers/message/fusion/mptbase.c
Date: Thu, 20 Jul 2017 17:28:49 -0600
Message-ID: <57b678ad0883a4eb902e47910a360c5c@cs.utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rio.cs.utah.edu ([155.98.64.241]:56222 "EHLO
        mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965416AbdGTXjt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jul 2017 19:39:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: DL-MPTFusionLinux@lsi.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kashyap.desai@lsi.com

Hi there,

My name is Shaobo He and I am a graduate student at University of Utah. 
I am using a static analysis tool to search for null pointer 
dereferences and came across a couple of potentially invalid memory 
accesses in the file drivers/message/fusion/mptbase.c: in function 
`mpt_turbo_reply`, variable `mf` is initialized to NULL. If the case 
`MPI_CONTEXT_REPLY_TYPE_SCSI_TARGET` is taken, then `mf` is not updated 
to a non-NULL value and then may get dereferenced in function 
`mpt_free_msg_frame`. However, there are a couple of conditions that can 
make the error path infeasible. I was wondering if you could confirm 
this.

Please let me know if it makes sense. I am looking forward to your 
reply.

Best,
Shaobo
