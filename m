From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 scsi] Short the path length of scsi_cmd_to_driver()
Date: Tue, 02 Oct 2012 18:22:49 -0400
Message-ID: <yq1626s4ipy.fsf@sermon.lab.mkp.net>
References: <1348464626.2475.13.camel@ThinkPad-T420>
	<1348465493.2467.3.camel@dabdike>
	<1348470210.2475.47.camel@ThinkPad-T420>
	<1348472104.2467.8.camel@dabdike> <yq13924b4uw.fsf@sermon.lab.mkp.net>
	<1348721055.2509.0.camel@dabdike> <yq1bogr8itb.fsf@sermon.lab.mkp.net>
	<1348818498.2411.8.camel@dabdike.int.hansenpartnership.com>
	<1348892617.6455.4.camel@ThinkPad-T420>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:37215 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2JBWW6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2012 18:22:58 -0400
In-Reply-To: <1348892617.6455.4.camel@ThinkPad-T420> (Li Zhong's message of
	"Sat, 29 Sep 2012 12:23:37 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

>>>>> "Li" == Li Zhong <zhong@linux.vnet.ibm.com> writes:

Li> As suggested by James: this patch tries to short the path length of
Li> scsi_cmd_to_driver(). As only REQ_TYPE_BLOCK_PC commands can be
Li> submitted without a driver, so we could avoid the related NULL
Li> checking, as long as we make sure we don't use it for
Li> REQ_TYPE_BLOCK_PC type commands. Plus, this fixes a bug where you
Li> get different behaviors from REQ_TYPE_BLOCK_PC commands when a
Li> driver is and isn't attached.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
