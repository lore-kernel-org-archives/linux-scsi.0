From: Nicolas Meaux <nicolas.meaux@artabel.net>
Subject: Re: crashing with sym53c8xx
Date: Mon, 29 Dec 2003 10:08:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FEFEF14.60905@artabel.net>
References: <0E3FA95632D6D047BA649F95DAB60E5703A751F2@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from artabel.net1.nerim.net ([62.212.107.173]:57236 "EHLO
	mail.artabel.net") by vger.kernel.org with ESMTP id S262925AbTL2JIi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 04:08:38 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703A751F2@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org

Moore, Eric Dean wrote:

>Nicolas - Here's a reply from Larry Stephens:
>  
>
First, sorry for the long delays reponse ...

>On Wednesday, December 17, 2003 9:23 AM, Larry Stephens wrote:
>  
>
>>Usually Parity errors are associated with bad cables or 
>>incorrect termination.  I'd suggest that the customer check 
>>and/or replace those items.  I don't suppose he has a SCSI 
>>bus analyzer so we could get a trace, does he?
>>    
>>
I changed some times the SCSI cable and the SCSI termination, but 
problems persisted, the problem is not new it occurred before i get the 
responsibility of this machine ( 1 year ).
And sorry, i dont have a bus analyzer, i will see if i can buy one.

>>I'd be interested to see if the same symptoms occur with the 
>>1030 and the mpt driver.  Any chance he could try the 1030?
>>
Sorry again, but i cannot try any new drivers, my raid partition crashed 
a few days ago, with strange logs.
Here they are :

kernel: SCSI disk error : host 1 channel 0 id 5 lun 0 return code = 100ff
kernel:  I/O error: dev 08:50, sector 779528
kernel: raid5: Disk failure on sdf, disabling device. Operation 
continuing on 5 devices
kernel: md: recovery thread got woken up ...
kernel: md2: resyncing spare disk sdd to replace failed disk
kernel: md: updating md2 RAID superblock on device
kernel: md: sdd [events: 00000062]<6>(write) sdd's sb offset: 35843584
kernel: RAID5 conf printout:
kernel:  --- rd:6 wd:5 fd:1
kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdh
kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb
kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc
kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdg
kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde
kernel:  disk 5, s:0, o:0, n:5 rd:5 us:1 dev:sdf
kernel: RAID5 conf printout:
kernel:  --- rd:6 wd:5 fd:1
kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdh
kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb
kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc
kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdg
kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde
kernel:  disk 5, s:0, o:0, n:5 rd:5 us:1 dev:sdf
kernel: md: syncing RAID array md2
kernel: md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
kernel: md: using maximum available idle IO bandwith (but not more than 
100000 KB/sec) for reconstruction.
kernel: md: using 124k window, over a total of 35843584 blocks.
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 779528
kernel: raid5: Disk failure on sdc, disabling device. Operation 
continuing on 4 devices
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 19008320
kernel: raid5: Disk failure on sde, disabling device. Operation 
continuing on 3 devices
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 19008320
kernel: raid5: Disk failure on sdh, disabling device. Operation 
continuing on 2 devices
kernel: SCSI disk error : host 1 channel 0 id 3 lun 0 return code = 100ff
kernel:  I/O error: dev 08:30, sector 71687168
kernel: md: write_disk_sb failed for device sdd
kernel: md: (skipping faulty sdf )
kernel: md: (skipping faulty sde )
kernel: md: sdg [events: 00000062]<6>(write) sdg's sb offset: 35843584
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 0
kernel: raid5: Disk failure on sdg, disabling device. Operation 
continuing on 1 devices
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 8
kernel: raid5: Disk failure on sdb, disabling device. Operation 
continuing on 0 devices
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 0
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 0
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 32
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 248
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 248
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 248
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 248
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 64
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 992
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 992
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 992
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 992
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 744
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 1736
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 1736
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 1736
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 1736
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 1488
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 8
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 496
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 496
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 496
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 40
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 256
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 1240
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 1240
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 1240
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 72
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 1000
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 1984
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 1984
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 1984
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 752
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 1744
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 744
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 744
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 744
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 1496
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 16
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 1488
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 1488
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 1488
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 48
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 264
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 16
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 8
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 8
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 80
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 1008
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 256
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 256
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 256
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 1736
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 1752
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 1000
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 1000
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 1000
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 248
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 24
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 1744
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 1744
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 1744
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 992
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 272
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 504
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 504
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 504
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 1984
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 1016
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 1248
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 1248
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 1248
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 496
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 1760
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 1992
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 1992
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 1992
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 1240
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 32
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 752
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 752
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 752
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 760
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 280
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 1496
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 1496
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 1496
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 1504
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 1024
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 24
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 16
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 16
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 88
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 1768
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 264
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 264
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 264
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 1744
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 40
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 1008
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 1008
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 1008
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 256
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 288
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 1752
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 1256
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 1256
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 504
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 2000
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 1504
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 1504
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 1512
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 32
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 1752
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 1752
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 1000
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 1032
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 512
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 2000
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 2000
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 1248
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 760
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 24
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 24
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 96
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 272
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 512
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 512
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 1992
kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
kernel:  I/O error: dev 08:60, sector 1776
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 1256
kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
kernel:  I/O error: dev 08:20, sector 760
kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
kernel:  I/O error: dev 08:40, sector 760
kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
kernel:  I/O error: dev 08:70, sector 768
kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
kernel:  I/O error: dev 08:10, sector 1504




Thanks in advance.
    Nicolas

