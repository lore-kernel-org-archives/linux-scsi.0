From: "Mukker, Atul" <atulm@lsil.com>
Subject: scsi timeout questions
Date: Thu, 19 Sep 2002 11:10:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57A8B48B@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mhbs.lsil.com (mhbs [147.145.31.100])
	by mail2.lsil.com (8.9.3+Sun/8.9.1) with ESMTP id IAA06397
	for <linux-scsi@vger.kernel.org>; Thu, 19 Sep 2002 08:10:57 -0700 (PDT)
Received: from atl1.se.lsil.com by mhbs.lsil.com with ESMTP for linux-scsi@vger.kernel.org; Thu, 19 Sep 2002 08:10:38 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

How can the default timeout value changed for scsi commands, per command
basis. Under certain circumstances ( e.g., rebuild and/or check consistency
on logical drives + heavy IO ), the megaraid F/W is not able to complete the
commands in default timeout period ( 60 seconds in 2.4.18-3) kernel.

Also, what is the expected behavior of the driver for aborted commands. The
commands which have been issued to f/w and are pending, the abort handler
returns "cannot abort". If such commands are later completed by the
firmware, the ISR completes the command with DID_ABORT. Is it ok?

TIA

Atul Mukker <Atul.Mukker@lsil.com>
Project Leader, RAID Device Drivers

RAID Storage Adapters Division
LSI Logic Corporation
6145-D Northbelt Parkway
Norcross GA - 30071
U.S.A.
