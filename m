From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup
 / early userspace transition
Date: Wed, 31 Jul 2013 19:51:09 +0200
Message-ID: <51F94E8D.5040908@fastmail.fm>
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm> <87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm> <87fvuxdqes.fsf@spindle.srvr.nix> <yq1txjdhree.fsf@sermon.lab.mkp.net> <51F80167.1080004@fastmail.fm> <yq1zjt3h11y.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1zjt3h11y.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nix <nix@esperi.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/31/2013 05:15 AM, Martin K. Petersen wrote:
>>>>>> "Bernd" == Bernd Schubert <bernd.schubert@fastmail.fm> writes:
> 
> Bernd,
> 
>>> Product revision level: R001 
> 
> It's clearly not verbatim passthrough...
> 
> Bernd> Besides the firmware, the difference might be that I'm exporting
> Bernd> single disks without any areca-raidset in between.  I can try to
> Bernd> confirm that tomorrow, I just need the system as it is till
> Bernd> tomorrow noon.
> 
> That would be a great data point. I don't have any Areca boards.
> 

Just tested it, areca-raidset does not make a difference, but the
firmware version does. After downgrading to 1.46 I have the same issue.

It is getting a bit late for me, but as this a pure development system,
which is also booted over nfs, I can investigate it tomorrow.


Cheers,
Bernd
