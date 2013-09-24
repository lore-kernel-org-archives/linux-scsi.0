From: Errol Neal <eneal@businessgrade.com>
Subject: Errors then crash Megaraid_sas v06.506.00.00-rc1
Date: Tue, 24 Sep 2013 13:48:11 -0400
Message-ID: <1380044891552985500@businessgrade.com>
Reply-To: eneal@businessgrade.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.businessgrade.com ([208.92.31.122]:36327 "EHLO
	smtp1.businessgrade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab3IXRxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Sep 2013 13:53:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi. I'm running Ubuntu 13.04 Raring on a Power Edge R515 with Dell H700 controller. I'm using kernel 3.10.12
Its a test platform and I'm driving quite a bit of i/o through it. Under load at times, the megaraid_sas driver will spit out the following error:

Sep 24 11:16:17 ubuntu1 kernel: [52243.873844] megasas: Err returned from build_and_issue_cmd
Sep 24 11:16:17 ubuntu1 kernel: [52243.933889] megasas: build_ld_io: sge_count = 65
Sep 24 11:16:17 ubuntu1 kernel: [52243.933894] megasas: Err returned from build_and_issue_cmd
Sep 24 11:16:17 ubuntu1 kernel: [52243.993934] megasas: build_ld_io: sge_count = 65
Sep 24 11:16:17 ubuntu1 kernel: [52243.993939] megasas: Err returned from build_and_issue_cmd
Sep 24 11:16:17 ubuntu1 kernel: [52244.053983] megasas: build_ld_io: sge_count = 65
Sep 24 11:16:17 ubuntu1 kernel: [52244.053988] megasas: Err returned from build_and_issue_cmd
Sep 24 11:16:17 ubuntu1 kernel: [52244.104031] megasas: build_ld_io: sge_count = 65


Then the server will hang/crash.

This is how the module is loaded into the kernel:

root@ubuntu1:/# cat /etc/modprobe.d/megaraid_sas.conf
options megaraid_sas max_sectors=2048

I'm planning on upgrading/testing kernel 3.11 or later to see if a driver update resolves things. 

Has anyone seen this issue before? 
