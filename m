From: "Mukker, Atul" <atulm@lsil.com>
Subject: [ANNOUNCE] megaraid linux driver version 2.00.7
Date: Fri, 1 Aug 2003 17:56:16 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570185F3DF@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "'linux-megaraid-devel@dell.com'" <linux-megaraid-devel@dell.com>
List-Id: linux-scsi@vger.kernel.org

MegaRAID driver version 2.00.7 is released and can be download from

ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.00.7/

Changes from 2.00.6:

i.	Adapter lock re-definition so that patch for kernels w/o per host
lock
	is less intrusive - Jens Axboe <axboe@suse.de>

ii.	While in abort and reset handling, check for non-empty pending list
is
	invalid. The intent is to wait for pending commands in FW to
complete,
	not the pending commands with the driver - Atul Mukker
<atulm@lsil.com>


Atul Mukker
Storage Systems
LSI Logic Corporation
