From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Report luns
Date: Wed, 10 Nov 2004 09:13:34 -0500
Message-ID: <4192220E.80805@adaptec.com>
References: <20041028143734.GA16358@beaverton.ibm.com> <20041028153522.GC1915@astral.ro> <20041028164210.GA16905@beaverton.ibm.com> <20041028172143.GA20949@praka.san.rr.com> <20041029085800.GF6671@astral.ro> <20041029180633.GA27267@beaverton.ibm.com> <20041101105611.GJ22603@astral.ro> <20041101194845.GA27913@us.ibm.com> <41903031.3050205@torque.net> <4190DCE0.1070606@adaptec.com> <20041109211055.GA11459@us.ibm.com> <41919D7B.5040703@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:45442 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261987AbUKJONx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 09:13:53 -0500
In-Reply-To: <41919D7B.5040703@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> 
> So now if one sends a REPORT LUNS to lun 0 that U320 disk is
> expected to know about its sibling disks!? That is why I used
> the term "hack" with respect to lun 0. What really happens
> is the device server in the bridge intercepts the REPORT LUNS
> command and produces a response reflecting its knowledge of
> those 5 U320 disks present. Why play this game? Why not talk
> directly to the device server (addressed via a well known lu).
> This way an INQUIRY to a W-LUN yields information about
> the bridge, while an INQUIRY to lun 0 yields information about
> that disk.

Very good point!

So we can reverse the logic into sending REPORT LUNS to
the REPORT LUNS W-LUN *first* and if this fails (most probably
in early years), then issue REPORT LUNS to LUN 0.

	Luben

