From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Wireless transport?
Date: Sun, 24 Apr 2005 18:07:24 -0700
Message-ID: <20050425010723.GA2734@us.ibm.com>
References: <Pine.LNX.4.60.0504242111090.3098@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:18364 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S262392AbVDYBHr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Apr 2005 21:07:47 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j3P17keE512504
	for <linux-scsi@vger.kernel.org>; Sun, 24 Apr 2005 21:07:46 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j3P17kpf260384
	for <linux-scsi@vger.kernel.org>; Sun, 24 Apr 2005 19:07:46 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j3P17jPl017428
	for <linux-scsi@vger.kernel.org>; Sun, 24 Apr 2005 19:07:45 -0600
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0504242111090.3098@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Sun, Apr 24, 2005 at 09:24:53PM +0200, Guennadi Liakhovetski wrote:
> Hi
> 
> An idle curiousity - some time ago I asked myself what would be the next 
> transport - wireless? Then a few weeks ago I saw a "wireless hard-drive" 
> in a local computer store. Didn't look at it closely, but I assume it 
> comes with an ad-hoc win driver.
> 
> So, the question is - is it happening? Any standards appearing? Any 
> drivers being developed? If there's anything - it would be logical to 
> assume that it would implement a SCSI protocol, would it become a new 
> transport?

No, just use iSCSI on top of the network.

You still need a hardware transport for the actual disks on the back end,
but SATA or IDE could be used over iSCSI via iSCSI software target (export
a block device, or file system file as a LUN).

-- Patrick Mansfield
