From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
Date: Mon, 29 Jul 2013 16:15:27 -0400
Message-ID: <yq138qxjf6o.fsf@sermon.lab.mkp.net>
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
	<87d2q1dteu.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87d2q1dteu.fsf@spindle.srvr.nix> (nix@esperi.org.uk's message of
	"Mon, 29 Jul 2013 21:04:41 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, nick.cheng@areca.com.tw
List-Id: linux-scsi@vger.kernel.org

>>>>> "Nix" == Nix  <nix@esperi.org.uk> writes:

Nix> spindle:/boot# sg_vpd --page=0x89 /dev/sda ATA information VPD
Nix> page: fetching VPD page failed

Please add -v

I'll also need the output of:

# sg_vpd -vl


Nix> I'll try rebooting into a kernel with that commit reverted next.

Doesn't matter as far as the sg commands are concerned...

-- 
Martin K. Petersen	Oracle Linux Engineering
