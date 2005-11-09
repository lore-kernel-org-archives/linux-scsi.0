From: Graham Knap <graham.knap@rogers.com>
Subject: Re: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Tue, 8 Nov 2005 20:47:13 -0500 (EST)
Message-ID: <20051109014713.78691.qmail@web88003.mail.re2.yahoo.com>
References: <1131459014.3270.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web88003.mail.re2.yahoo.com ([206.190.37.190]:60542 "HELO
	web88003.mail.re2.yahoo.com") by vger.kernel.org with SMTP
	id S964987AbVKIBrO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Nov 2005 20:47:14 -0500
In-Reply-To: <1131459014.3270.1.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Horms <horms@debian.org>
Cc: Graham Knap <graham.knap@rogers.com>, 338089@bugs.debian.org, linux-scsi@vger.kernel.org

Graham Knap <graham.knap@rogers.com> wrote:
> Recent versions of the aic7xxx driver will not boot on my secondary
> PC. The 2.6.8 kernel shipped with sarge works, but neither the 2.6.12
> kernel in testing nor the 2.6.14 kernel in unstable will boot.
> This is an older system: 
> Asus P2L-B, Celeron 500MHz, 384MB RAM, GeForce2 MX AGP
> Adaptec 2940UW, IBM DDYS-T09170 (9GB disk)

Horms <horms@debian.org> wrote:
> This does smell a lot like a driver bug, and as such, its proably
> best passed onto the upstream maintainers.

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> This is an older drive, so it looks like it passes domain validation
> (read only) but then chokes on the next command.  On 2.6.8, what do
> the transport settings report? (that's cat /proc/scsi/aic7xxx/0)?


Thanks for responding so quickly. Here's what I see on 2.6.8.

graham@testbox:~$ uname -a
Linux testbox 2.6.8-2-686 #1 Thu May 19 17:53:30 JST 2005 i686
GNU/Linux

graham@testbox:~$ cat /proc/scsi/aic7xxx/0
Adaptec AIC7xxx driver version: 6.2.36
Adaptec 2940 Ultra SCSI adapter
aic7880: Ultra Wide Channel A, SCSI Id=7, 16/253 SCBs
Allocated SCBs: 12, SG List Length: 128

Serial EEPROM:
0x02f8 0x02f8 0x02f8 0x02f8 0x02f8 0x02f8 0x02f8 0x02f8
0x02f8 0x02f8 0x02f8 0x02f8 0x02f8 0x02f8 0x02f8 0x02f8
0x18a6 0x005f 0x2807 0x0010 0xff00 0xffff 0xffff 0xffff
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x00ff 0x7092

Target 0 Negotiation Settings
        User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
        Goal: 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
        Curr: 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
        Channel A Target 0 Lun 0 Settings
                Commands Queued 49075
                Commands Active 0
                Command Openings 8
                Max Tagged Openings 8
                Device Queue Frozen Count 0
Target 1 Negotiation Settings
        User: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)

<snip> ... Target 0 is the only device, so I assume that the remaining
output is meaningless.

Let me know if there's anything else I can do to help.

-- graham
