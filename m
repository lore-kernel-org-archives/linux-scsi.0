From: Kurt Miller <kurt@intricatesoftware.com>
Subject: Re: LSI SAS - SSDs with DRAT and DZAT
Date: Fri, 18 Apr 2014 11:23:06 -0400
Message-ID: <1397834586.12035.14.camel@sonic.justonedata.com>
References: <1391730975.3449.16.camel@sonic.justonedata.com>
	 <yq1vbwqslek.fsf@sermon.lab.mkp.net>
	 <1391806363.2761.8.camel@sonic.justonedata.com>
	 <yq1mwi2skoz.fsf@sermon.lab.mkp.net>
	 <1391808293.2761.9.camel@sonic.justonedata.com>
	 <yq1iosqs8fx.fsf@sermon.lab.mkp.net>
	 <1391984895.13523.13.camel@tardis.intricatesoftware.com>
	 <1392172050.2761.37.camel@sonic.justonedata.com>
	 <53481EEE.3090405@itwm.fraunhofer.de> <yq1lhv3eoaf.fsf@sermon.lab.mkp.net>
	 <1397773953.12035.2.camel@sonic.justonedata.com>
	 <CAN7X1Un4=dTyvRbyt=0j6Q+=OBcXRDB+0J+dLPZCboKdxyTTzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 4133fa24.cst.lightpath.net ([65.51.250.36]:45879 "EHLO
	mail1.intricatesoftware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988AbaDRPXQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2014 11:23:16 -0400
In-Reply-To: <CAN7X1Un4=dTyvRbyt=0j6Q+=OBcXRDB+0J+dLPZCboKdxyTTzQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Purush Gupta <purush.gupta@nutanix.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, linux-scsi@vger.kernel.org

On Thu, 2014-04-17 at 16:10 -0700, Purush Gupta wrote:
> Kurt, Just curious which LSI firmware version are you using?

currently 18.

Intel S3500 on LSI SAS 9207-8i IT:
Linux thorin 3.11.0-12-generic #19-Ubuntu SMP Wed Oct 9 16:20:46 UTC
2013 x86_64 x86_64 x86_64 GNU/Linux
[    3.077947] mpt2sas0: LSISAS2308: FWVersion(18.00.00.00),
ChipRevision(0x05), BiosVersion(07.22.01.00)
[    3.276611] scsi 1:0:1:0: Direct-Access     ATA      INTEL SSDSC2BB48
0355 PQ: 0 ANSI: 6
[    3.528271] sd 1:0:1:0: [sdb] 937703088 512-byte logical blocks: (480
GB/447 GiB)
cat /sys/block/sdb/queue/discard_granularity 
512

Samsung 840 Pro on LSI 9211-8i IT:
Linux gloin 3.11.0-12-generic #19-Ubuntu SMP Wed Oct 9 16:20:46 UTC 2013
x86_64 x86_64 x86_64 GNU/Linux
[    2.948533] mpt2sas0: LSISAS2008: FWVersion(18.00.00.00),
ChipRevision(0x03), BiosVersion(07.35.00.00)
[    2.968993] scsi 2:0:1:0: Direct-Access     ATA      Samsung SSD 840
5B0Q PQ: 0 ANSI: 6
[    2.976587] sd 2:0:1:0: [sdb] 1000215216 512-byte logical blocks:
(512 GB/476 GiB)
cat /sys/block/sdb/queue/discard_granularity 
512

-Kurt

