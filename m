From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: SSC-2 support in Linux
Date: Wed, 15 Sep 2004 09:25:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <414842E7.2020800@adaptec.com>
References: <82C736F456CA3E4EA3D0DC6CC31AA5CB01651157@esply09.cnt.ad.cnt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:6044 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266006AbUION0G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 09:26:06 -0400
In-Reply-To: <82C736F456CA3E4EA3D0DC6CC31AA5CB01651157@esply09.cnt.ad.cnt.com>
List-Id: linux-scsi@vger.kernel.org
To: "David Peterson (Eng)" <david_peterson@cnt.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

David Peterson (Eng) wrote:
> I'd like to hear from anyone interested, or has looked into, adding
> support for SSC-2 (SCSI Stream Commands -2, i.e., tape devices) explicit
> address mode into the Linux OS.
> 
> In summary, SSC-2 explicit address mode enables for tape devices:
> - robust tagged command queuing
> - multi-path I/O
> - enhanced error detection and recovery

Looks like those should all be part of a larger effort,
as they are needed across SCSI Core.

	Luben

