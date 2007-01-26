From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: Fw: SAS1068 PCI-X Fusion-MPT SAS 1000:0055
Date: Fri, 26 Jan 2007 14:53:20 -0500
Message-ID: <45BA5C30.9050901@ce.jp.nec.com>
References: <20070126021907.559f23c9.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161242AbXAZTyO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jan 2007 14:54:14 -0500
In-Reply-To: <20070126021907.559f23c9.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: areq@areq.eu.org
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, "Moore, Eric Dean" <Eric.Moore@lsil.com>

Hi,

> I have new NEC server with SAS1068 PCI-X Fusion-MPT SAS
> pciid: 1000:0055
> mptsas form 2.6.20-rc5 don't recognize it ;(
> 
> I see that driver support only 1000:0054 and 1000:0058 devices.

It might be that the device has software RAID feature and changes
device ID based on setup. (1000:0055 when software RAID is enabled
and 1000:0054 or something for normal SAS)

If so, there is a chance you can disable the software RAID
via BIOS setup utility.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America
