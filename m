From: Newtech Tan <tan@newtech.co.jp>
Subject: Do anybody know the format of bsg device node name?
Date: Tue, 10 Dec 2013 10:32:47 +0900
Message-ID: <20131210103247.9151.46AD7750@newtech.co.jp>
References: <20131209194650.27687.56358.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dc31.etius.jp ([119.245.209.2]:51650 "EHLO dc31.etius.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab3LJBct (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Dec 2013 20:32:49 -0500
In-Reply-To: <20131209194650.27687.56358.stgit@viggo.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


For example of bsg device node name: 
[4:0:0:0]

Each field is Hex or Dec?

[BackGroup]
I am using lsscsi -g command to get SCSI device list as the following.
If bsg device name's target number field is over ten, Will it display [4:0:10:0] or [4:0:a:0]?

# lsscsi -g
[0:0:0:0]    cd/dvd  HL-DT-ST DVD+-RW GSA-H53N B104  /dev/sr0   /dev/sg0
[3:0:0:0]    disk    ATA      WDC WD1600AAJS-1 05.0  /dev/sda   /dev/sg1
[4:0:0:0]    disk    ATA      Hitachi HDT72102 A31B  /dev/sdb   /dev/sg2
[4:0:1:0]    disk    ATA      Hitachi HDT72502 A73A  /dev/sdc   /dev/sg3
[4:0:2:0]    disk    ATA      Hitachi HDT72502 A73A  /dev/sdd   /dev/sg4
[4:0:3:0]    disk    ATA      Hitachi HDT72502 A73A  /dev/sde   /dev/sg5
[4:0:4:0]    disk    ATA      Hitachi HDT72502 A73A  /dev/sdf   /dev/sg6
[4:0:5:0]    disk    ATA      Hitachi HDT72502 A73A  /dev/sdg   /dev/sg7
[4:0:6:0]    disk    ATA      Hitachi HDT72502 A73A  /dev/sdh   /dev/sg8
[4:0:7:0]    disk    ATA      Hitachi HDT72502 A73A  /dev/sdi   /dev/sg9
[4:0:8:0]    enclosu LSI      SAS616x          0502  -         /dev/sg10

Thanks !
