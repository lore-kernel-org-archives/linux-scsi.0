From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Report luns [was: Apple Xserve RAID and qlogic ISP2312 (qla2300)]
Date: Wed, 10 Nov 2004 09:47:59 -0500
Message-ID: <41922A1F.7060705@adaptec.com>
References: <20041027233321.GA842@astral.ro> <20041028143734.GA16358@beaverton.ibm.com> <20041028153522.GC1915@astral.ro> <20041028164210.GA16905@beaverton.ibm.com> <20041028172143.GA20949@praka.san.rr.com> <20041029085800.GF6671@astral.ro> <20041029180633.GA27267@beaverton.ibm.com> <20041101105611.GJ22603@astral.ro> <20041101194845.GA27913@us.ibm.com> <41903031.3050205@torque.net> <4190DCE0.1070606@adaptec.com> <4191A4F5.2040300@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:15770 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261917AbUKJOsO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 09:48:14 -0500
In-Reply-To: <4191A4F5.2040300@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> 
> SAS expanders (or at least their SMP target ports) are
> a similar problem to W-LUNs. Namely we have no way to
> "talk" to them from the user space currently in Linux.
> SMP is not a SCSI command set (but it is close). Even if
> sg could issue SMP commands, I'm not sure the scsi mid
> level would be helpful when error conditions occurred
> (e.g. SMP command timeout).
> 
> As for the addressability problem, sockets and connect
> calls come to mind.

Yeah, that's a pickle.

	Luben


