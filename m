From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
Date: Mon, 29 Jul 2013 19:34:33 -0400
Message-ID: <yq1txjdhree.fsf@sermon.lab.mkp.net>
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
	<87fvuxdqes.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87fvuxdqes.fsf@spindle.srvr.nix> (nix@esperi.org.uk's message of
	"Mon, 29 Jul 2013 22:09:31 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, nick.cheng@areca.com.tw, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Nix" == Nix  <nix@esperi.org.uk> writes:

Bernd,

Nix> I can now confirm that reverting this commit causes this problem to
Nix> go away, and my machine boots fine again.

Can you please send me the output of sq_inq with your 1.49 firmware?

I made a tweak that allowed Nix to boot but we're trying to find a good
blacklist trigger. And that's tricky given that Areca allows you
manually specify the SCSI model string for each volume...

-- 
Martin K. Petersen	Oracle Linux Engineering
