From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Report luns [was: Apple Xserve RAID and qlogic ISP2312 (qla2300)]
Date: Tue, 09 Nov 2004 17:07:16 -0500
Message-ID: <41913F94.4030003@adaptec.com>
References: <20041028143734.GA16358@beaverton.ibm.com> <20041028153522.GC1915@astral.ro> <20041028164210.GA16905@beaverton.ibm.com> <20041028172143.GA20949@praka.san.rr.com> <20041029085800.GF6671@astral.ro> <20041029180633.GA27267@beaverton.ibm.com> <20041101105611.GJ22603@astral.ro> <20041101194845.GA27913@us.ibm.com> <41903031.3050205@torque.net> <4190DCE0.1070606@adaptec.com> <20041109211055.GA11459@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:8414 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261722AbUKIWHc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2004 17:07:32 -0500
In-Reply-To: <20041109211055.GA11459@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> Do we also have to change to send the INQUIRY to the well known LUN?
> 
> And then someday add black and white list flags and code for them ...
> 
> Why is stuff like this even added to the standard??? Why not use LUN 0
> (all zeroes) or at worst have one well known LUN like the all f's?
> 
> The hierarchical LUN stuff and the various address modes are dumb, just
> treat the LUN as a tag/identifier (similiar to a TCP/IP network port) and
> leave the interpretation of it up to the target device (or at worst the
> transport).

And I believe this is what a lot of vendors will do: support
REPORT LUN on LUN 0 regardless if whether there's a device
there or not.  BTW the standard says "LUN 0 or REPORT LUNS W-LUN",
so the vendors would take advantage of this for compatibility.

	Luben


