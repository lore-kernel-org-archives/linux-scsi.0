From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
Date: Mon, 29 Jul 2013 10:26:36 -0400
Message-ID: <yq11u6hl9wj.fsf@sermon.lab.mkp.net>
References: <87r4ehfzhf.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87r4ehfzhf.fsf@spindle.srvr.nix> (Nick Alcock's message of "Mon,
	29 Jul 2013 11:10:36 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Alcock <nix@esperi.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, nick.cheng@areca.com.tw
List-Id: linux-scsi@vger.kernel.org

>>>>> "Nick" == Nick Alcock <nix@esperi.org.uk> writes:

Nick> My server's ARC-1210 has been working fine for years, but when I
Nick> upgraded from 3.10.1, it started failing:

Nick> [ 0.784044] Areca RAID Controller0: F/W V1.46 2009-01-06 & Model
Nick> ARC-1210 [ 0.804028] scsi0 : Areca SATA Host Adapter RAID
Nick> Controller
Nick>  Driver Version 1.20.00.15 2010/08/05
Nick> [...]

Interesting. Please provide the output of:

# sg_inq /dev/sdd
# sg_vpd /dev/sdd
# sg_vpd -p ai /dev/sdd

-- 
Martin K. Petersen	Oracle Linux Engineering
