From: Grant Grundler <iod00d@hp.com>
Subject: convert 520 byte sector disk to 512 byte sector?
Date: Mon, 9 Jun 2003 10:46:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609174647.GB29808@cup.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel12.hp.com ([156.153.255.237]:65431 "EHLO palrel12.hp.com")
	by vger.kernel.org with ESMTP id S264569AbTFIRdH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2003 13:33:07 -0400
Received: from hpuxmail.cup.hp.com (hpuxmail.cup.hp.com [15.13.189.207])
	by palrel12.hp.com (Postfix) with ESMTP id 4D1E21C016F5
	for <linux-scsi@vger.kernel.org>; Mon,  9 Jun 2003 10:46:46 -0700 (PDT)
Received: from debian.cup.hp.com (postfix@[15.244.57.47])
	by hpuxmail.cup.hp.com (8.11.1/8.8.6) with ESMTP id h59HmMT05103
	for <linux-scsi@vger.kernel.org>; Mon, 9 Jun 2003 10:48:22 -0700 (PDT)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I've got several ST336753FC and ST336704FC disks which came out
of a VA7100 RAID enclosure. The VA7100 is able to reformat those
disks from 512 to 520 bytes per sector. I'd like to convert them
back to 512 byte/sector for use as "regular" disks.
Anyone know the trick to do that?

I once wrote a program to use scsi-pass thru (aka scsi generic)
under HPUX to do exactly that for regular parallel SCSI disks.
I dug that up, dusted it off and ported it to linux.
Source code is on http://gsyprf11.external.hp.com/blk512/

I haven't tried blk512-linux with parallel SCSI under linux,
but I know it's not working with the above FC disks when run
on an ia64-linux box.  The format mode page "current" values
aren't changing using the "trick" that worked for the parallel
SCSI disks. And the "writeable" indicates none of the formt mode
page parameters are allowed to be changed (clearly a lie).

The default format mode page clearly shows the drive was 512 byte/sector.
I'd just like to get them back to that for the some performance testing.

thanks,
grant
