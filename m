From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [set3 PATCH 3/6] libsas: fix sas_discover_devices return code handling
Date: Fri, 22 Jun 2012 15:03:45 +0800
Message-ID: <0A5B34181B074D459DCDB5A59168431F@usish.com.cn>
References: <20120622063604.21332.39275.stgit@dwillia2-linux.jf.intel.com> <20120622063620.21332.68813.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:35270 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761418Ab2FVHEs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2012 03:04:48 -0400
In-Reply-To: <20120622063620.21332.68813.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org
Cc: 'Dan Melnic' <dan.melnic@amd.com>, stable@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>, 'Tom Peng' <tom_peng@usish.com>

> commit 198439e4 [SCSI] libsas: do not set res = 0 in sas_ex_discover_dev()
> commit 19252de6 [SCSI] libsas: fix wide port hotplug issues
> 
> The above commits seem to have confused the return value of
> sas_ex_discover_dev which is non-zero on failure and
> sas_ex_join_wide_port which just indicates short circuiting discovery on
> already established ports.  The result is random discovery failures
> depending on configuration.
> 
> Calls to sas_ex_join_wide_port are the source of the trouble as its
> return value is errantly assigned to 'res'.  Convert it to bool and stop
> returning its result up the stack.
[Jack Wang] 
Thanks for fix, looks OK to me.
Please add my Reviewed-by if needed.


