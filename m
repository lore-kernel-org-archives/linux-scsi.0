From: "Wu Zhou" <zhouwu@cn.ibm.com>
Subject: Re: aic7xxx & st - why does sym driver don't like odd count on wide bus?
Date: Wed, 13 Aug 2003 11:50:32 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF8C687201.E0196FA8-ON48256D81.0012E224@cn.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausmtp02.au.ibm.com ([202.81.18.187]:32445 "EHLO
	ausmtp02.au.ibm.com") by vger.kernel.org with ESMTP id S271372AbTHMDtZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Aug 2003 23:49:25 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kai.Makisara@kolumbus.fi

Hi, Kai

      You ever said that sym driver doesn't like odd counts on wide bus.
What I want to know is why. Is this a defect? I ever try the following
command:

[root@plinuxt17 root]# mt -f /dev/st0 setblk 0
[root@plinuxt17 root]# dd if=/dev/zero of=/dev/st0 bs=1025 count=1
1+0 records in
1+0 records out
dd: closing output file `/dev/st0': Input/output error

and running "dmesg" will show the following message:
st0: Block limits 1 - 16777215 bytes.
st0: Mode sense. Length 11, medium 34, WBS 10, BLL 8
st0: Density 26, tape length: 0, drv buffer: 1
st0: Block size: 0, buffer size: 32768 (1 blocks).
sym53c896-1-<0,0>: extraneous data discarded.
sym53c896-1-<0,0>: COMMAND FAILED (89 0) @c0000002fce6a800.
st0: Error: 27070000, cmd: a 0 0 4 1 0 Len: 1025
st0: Async write error (flush) 27070000.
st0: Rewinding tape.

If it is real that sym driver doesn't like odd counts, then how to explain
the following command return no error(sdf and st0 are on the same sym53c896
adapter). I am quite new to SCSI, and just curious about that.

Thanks and Best Regards
---------------------------------------------
Zhou, Wu
Software Engineer, IBM China Development Lab
Email: zhouwu@cn.ibm.com
Notes: Wu Zhou/China/IBM@IBMCN

