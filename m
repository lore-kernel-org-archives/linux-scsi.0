From: "Steve Jones" <Steve.Jones@softhome.net>
Subject: SCC Logical Unit Addressing
Date: Tue, 6 Jul 2004 19:31:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <courier.40EAF018.00000541@softhome.net>
References: <0E3FA95632D6D047BA649F95DAB60E5704ABF284@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jive.SoftHome.net ([66.54.152.27]:47052 "HELO jive.SoftHome.net")
	by vger.kernel.org with SMTP id S264305AbUGFTMr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2004 15:12:47 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5704ABF284@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 
I'm trying to configure lk2.4.20 with an Emulex LP8000 
HBA and Emulex' driver into a Crossroads 4100 FC/SCSI 
Bridge in SCC addressing mode. In order to do this, I 
have to encode a bus/target/lun triplet into the FC LUN 
field _and_ set the addressing mode to 10b so as to 
select the appropriate device on the SCSI side of the 
Crossroads box. Doing this results in an FC LUN field 
with values above 0x8000. I don't actually need a large 
number of LUNs, but do need to use these high values 
in order to select the LUN of choice. 

The Emulex HBA driver restricts me to 128 LUNs (0-127) 
or, perhaps, 256 LUNs depending on how one reads the 
comments in the code. I've tried to kludge the driver 
into accepting higher values but cannot be sure that the 
driver is even receiving such high values from the mid-
layer.

Can anyone tell me if lk2.4.X is able to cope with first 
level (2-byte) FCP/SCC LUN addressing at all, or am I 
wasting my time here? If the former, how can I activate a 
level of tracing/debugging in the mid-layer sufficient to 
reveal the contents of SCSI command blocks?


Thanks, and regards

Steve Jones
steve.jones@softhome.net

