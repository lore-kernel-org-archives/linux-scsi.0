From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: Fwd: 32bit dev_t
Date: Tue, 28 Jan 2003 08:33:00 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF6219FB58.D7DE4198-ON87256CBC.0059CD9E-88256CBC.005B0ABA@us.ibm.com>
References: <1043752867.1328.10.camel@dhcp22.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.194.23])
	by e31.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id h0SGY8cb060036
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2003 11:34:09 -0500
Received: from d03nm031.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay02.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id h0SGXxD2216154
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2003 09:33:59 -0700
In-Reply-To: <1043752867.1328.10.camel@dhcp22.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>





This has probably been discussed to death somewhere, but I missed it:  Why
are people with hundreds of disks messing around with piles of major
numbers and eliminating disk partitioning instead of just using devfs?
Doesn't that make dev_t pretty much irrelevant?

