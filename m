From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: EBDA Question
Date: Mon, 7 Feb 2005 12:45:17 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C01297B87@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

EBDA - Extended Bios Data Area

Does Linux and various boot loaders(lilo/grub/etc)
having any restrictions on where and how big 
memory allocated in EBDA is? Is this
handled for 2.4/2.6 Kernels?

Reason I ask is we are considering having
BIOS(for a SCSI HBA Controller) allocating
memory in EBDA for Firmware use. 
We are concerned whether Linux would be writing
over this region of memory during the handoff
of BIOS to scsi lower layer driver loading.

Eric Moore
LSI Logic
