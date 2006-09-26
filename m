From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Subject: Re: [PATCH] scsi/mptsas: add RAID devices in ascending ID order
Date: Tue, 26 Sep 2006 14:12:53 +0200
Message-ID: <45191945.6050105@fujitsu-siemens.com>
References: <664A4EBB07F29743873A87CF62C26D7032D7EB@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dgate1.fujitsu-siemens.com ([217.115.66.35]:24359 "EHLO
	dgate1.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S1751166AbWIZMM4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Sep 2006 08:12:56 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7032D7EB@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, mpt_linux_developer <mpt_linux_developer@lsil.com>

Moore, Eric wrote:

> You patch will call scsi_add_device, from low to hi target 
> ids, right?  Well if someone creates a volume that
> is issued target id=8, installs the operating system.
> Then tommorrow they create a new volume that is issued
> target id=7, then what your patch will do is reverse
> the order, right?  If so, a panic would occur
> unless they assigned device names/lables.

Yes, if the order of VolumeIDs assigned by the firmware is indeed 
random. That's not what was observed in our test lab, though.

Anyway, I'll just advise people to use persistent device names, thank you.

Regards
Martin

-- 
Martin Wilck                Phone: +49 5251 8 15113
Fujitsu Siemens Computers   Fax:   +49 5251 8 20409
Heinz-Nixdorf-Ring 1        mailto:Martin.Wilck@Fujitsu-Siemens.com
D-33106 Paderborn           http://www.fujitsu-siemens.com/primergy
