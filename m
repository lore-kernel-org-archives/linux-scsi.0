From: Mark Lord <kernel@start.ca>
Subject: Re: [PATCH 1/3] sd: don't bother spinning up disks on resume
Date: Sat, 16 Nov 2013 00:23:00 -0500
Message-ID: <52870134.6060707@start.ca>
References: <527AF287.7020700@ubuntu.com> <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com> <527BDA11.6060603@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mouse.start.ca ([64.140.120.56]:56339 "EHLO mouse.start.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab3KPFYs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Nov 2013 00:24:48 -0500
In-Reply-To: <527BDA11.6060603@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, Phillip Susi <psusi@ubuntu.com>, todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: tj@kernel.org, JBottomley@parallels.com

On 13-11-07 01:21 PM, Douglas Gilbert wrote:
> On 13-11-06 08:57 PM, Phillip Susi wrote:
>> Don't bother forcing disks to spin up on resume, as they
>> will do so automatically when accessed, and forcing them
>> to spin up slows down the resume.  Add a second bit to the
>> manage_start_stop flag to restore the previous behavior.
> 
> SCSI disks when in STOP state do not spin up "automatically
> when accessed".
..

Ditto for many SATA disks with "power up in standby" enabled.


