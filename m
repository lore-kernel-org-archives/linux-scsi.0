From: Vinay Venkataraghavan <raghavanvinay@yahoo.com>
Subject: Number of devices that SCSI can support
Date: Tue, 8 Jan 2008 16:55:46 -0800 (PST)
Message-ID: <404714.86520.qm@web43145.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n7a.bullet.ukl.yahoo.com ([217.146.183.155]:35334 "HELO
	n7a.bullet.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758221AbYAIBBh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 20:01:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: raghavanvinay@yahoo.com

Hello everybody,

Is there a limit on the number of devices that SCSI supports. In other words, I have a QLogic HBA card, and I am connecting to a SAN which has 64 targets. 

I also have one local SCSI disk.  So the total number of targets that I need to see is 65. 

So now what happens is that all but ONE disc/target gets correctly mapped and a device file is created except for one. This happens to be /dev/sdbm which maps to /dev/sg64

Looks like the SCSI midlayer also sees the target but the only thing that does not seem to happen is that the device file /dev/sdbm is not getting created.

I am attaching below the output: 

If you go all the way down, the last entry which is a valid disc gets mapped correctly but a /dev/sdbm device file does not get created. 

Any thoughts as to why this is happening. Is there a limitation on SCSI ability to handle only 64 discs? I would really appreciate any help.

I am running 2.6.9-42. 

I might be wrong, but I think i tried this same configuration on RHEL5 and I think it works. I will double check though. Was there a patch that was applied to fix this issue. 

Thanks in advance. 

Vinay


[root@localhost ~]# sg_map -x
/dev/sg0  0 0 0 0  0  /dev/sda
/dev/sg1  2 0 0 0  0  /dev/sdb
/dev/sg2  2 0 1 0  0  /dev/sdc
/dev/sg3  2 0 2 0  0  /dev/sdd
/dev/sg4  2 0 3 0  0  /dev/sde
/dev/sg5  2 0 4 0  0  /dev/sdf
/dev/sg6  2 0 5 0  0  /dev/sdg
/dev/sg7  2 0 6 0  0  /dev/sdh
/dev/sg8  2 0 7 0  0  /dev/sdi
/dev/sg9  2 0 8 0  0  /dev/sdj
/dev/sg10  2 0 9 0  0  /dev/sdk
/dev/sg11  2 0 10 0  0  /dev/sdl
/dev/sg12  2 0 11 0  0  /dev/sdm
/dev/sg13  2 0 12 0  0  /dev/sdn
/dev/sg14  2 0 13 0  0  /dev/sdo
/dev/sg15  2 0 14 0  0  /dev/sdp
/dev/sg16  2 0 15 0  0  /dev/sdq
/dev/sg17  2 0 16 0  0  /dev/sdr
/dev/sg18  2 0 17 0  0  /dev/sds
/dev/sg19  2 0 18 0  0  /dev/sdt
/dev/sg20  2 0 19 0  0  /dev/sdu
/dev/sg21  2 0 20 0  0  /dev/sdv
/dev/sg22  2 0 21 0  0  /dev/sdw
/dev/sg23  2 0 22 0  0  /dev/sdx
/dev/sg24  2 0 23 0  0  /dev/sdy
/dev/sg25  2 0 24 0  0  /dev/sdz
/dev/sg26  2 0 25 0  0  /dev/sdaa
/dev/sg27  2 0 26 0  0  /dev/sdab
/dev/sg28  2 0 27 0  0  /dev/sdac
/dev/sg29  2 0 28 0  0  /dev/sdad
/dev/sg30  2 0 29 0  0  /dev/sdae
/dev/sg31  2 0 30 0  0  /dev/sdaf
/dev/sg32  2 0 31 0  0  /dev/sdag
/dev/sg33  2 0 32 0  0  /dev/sdah
/dev/sg34  2 0 33 0  0  /dev/sdai
/dev/sg35  2 0 34 0  0  /dev/sdaj
/dev/sg36  2 0 35 0  0  /dev/sdak
/dev/sg37  2 0 36 0  0  /dev/sdal
/dev/sg38  2 0 37 0  0  /dev/sdam
/dev/sg39  2 0 38 0  0  /dev/sdan
/dev/sg40  2 0 39 0  0  /dev/sdao
/dev/sg41  2 0 40 0  0  /dev/sdap
/dev/sg42  2 0 41 0  0  /dev/sdaq
/dev/sg43  2 0 42 0  0  /dev/sdar
/dev/sg44  2 0 43 0  0  /dev/sdas
/dev/sg45  2 0 44 0  0  /dev/sdat
/dev/sg46  2 0 45 0  0  /dev/sdau
/dev/sg47  2 0 46 0  0  /dev/sdav
/dev/sg48  2 0 47 0  0  /dev/sdaw
/dev/sg49  2 0 48 0  0  /dev/sdax
/dev/sg50  2 0 49 0  0  /dev/sday
/dev/sg51  2 0 50 0  0  /dev/sdaz
/dev/sg52  2 0 51 0  0  /dev/sdba
/dev/sg53  2 0 52 0  0  /dev/sdbb
/dev/sg54  2 0 53 0  0  /dev/sdbc
/dev/sg55  2 0 54 0  0  /dev/sdbd
/dev/sg56  2 0 55 0  0  /dev/sdbe
/dev/sg57  2 0 56 0  0  /dev/sdbf
/dev/sg58  2 0 57 0  0  /dev/sdbg
/dev/sg59  2 0 58 0  0  /dev/sdbh
/dev/sg60  2 0 59 0  0  /dev/sdbi
/dev/sg61  2 0 60 0  0  /dev/sdbj
/dev/sg62  2 0 61 0  0  /dev/sdbk
/dev/sg63  2 0 62 0  0  /dev/sdbl
/dev/sg64  2 0 63 0  0









      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs

