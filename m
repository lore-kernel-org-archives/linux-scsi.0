From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380
 drivers
Date: Thu, 19 Nov 2015 15:52:43 +1300
Message-ID: <564D397B.3070207@gmail.com>
References: <20151118083455.331768508@telegraphics.com.au> <201511181235.15663.linux@rainbow-software.org> <alpine.LNX.2.00.1511191321010.9967@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1511191321010.9967@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Sam Creasey <sammy@sammy.net>, Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

>>>
>>> I have compile-tested all patches to all NCR5380 drivers (x86, ARM, 
>>> m68k) and regression tested mac_scsi and dmx3191d modules on suitable 
>>> hardware. Testing the mac_scsi and dmx3191d modules provides only 
>>> limited coverage. It would be good to see some testing of ISA cards 
>>> and Sun 3 and Atari hardware too (I don't have any).
>>
>> I have some NCR5380 ISA cards and can test them.
>>
> 
> Thanks Ondrej. I've no idea which ISA drivers are presently working in 
> mainline. Finding regressions may be more difficult than usual ;-)
> 
> Michael, Sam: only atari_scsi and sun3_scsi implement DMA support, so some
> testing of either driver would be helpful.

One way or another, I'll test this series or get someone to test a
kernel I built.

Cheers,
	
	Michael
