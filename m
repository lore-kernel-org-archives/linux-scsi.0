From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SCSI vs IDE
Date: Tue, 31 Aug 2004 17:28:16 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41342890.3050501@torque.net>
References: <20040831050117.80689.qmail@web53204.mail.yahoo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:53676 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S267310AbUHaH26 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2004 03:28:58 -0400
In-Reply-To: <20040831050117.80689.qmail@web53204.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Linux Explorer <erforschen_linux@yahoo.com>
Cc: linux-scsi@vger.kernel.org

Linux Explorer wrote:
> Hi,
> 
> I am using SCSI disk for backup operation, and I found
> out that it takes long time than IDE disk.
> 
> Herewith I attach the two text files they give the
> time taken for SCSI and IDE disks for writing 4728MB
> of data using dd command.
> 
> Can anyone tell me , why SCSI disk takes approximately
> 3 times as IDE disk?
> 
> Herewith I attach one more text file inq.txt which
> gives the Inquiry information of the attached scsi
> disk.
> 
> I have tried this with adaptec and LSI logic scsi
> controllers, both are taking same time.

It is good to see that Digital Equipment Corporation SCSI-2
disks are still going strong. So I guess it is not a Ultra
320 or SAS disk running at 15,000 rpm. Current SCSI disks
are approaching transfer speeds of 100 MB/sec while your
measurement shows a write speed of 11 MB/sec.

What vintage is the IDE (ATA) disk that you are using for
comparison? Your measurement shows a write speed of 33
MB/sec.

About the only thing that might be tweaked with your
hardware is write caching. ATA disks seem to have it
on all the time. For your SCSI disk, in scu try:
"show pages cache-control" and look at the "Write Cache Enable"
state. If it says "No" then use scu to set it to "Yes" and
retest.

Doug Gilbert
