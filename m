From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH] m68k/atari: atari_scsi.c - use m68k_realnum_memory for
 FastRAM test
Date: Tue, 6 Jun 2017 15:38:52 +1200
Message-ID: <c37703ec-caa9-c431-9260-0a1b1deab694@gmail.com>
References: <1496648279-15702-1-git-send-email-schmitzmic@gmail.com>
 <20170605191709.GB4005@nunzio.venus.sol>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20170605191709.GB4005@nunzio.venus.sol>
Sender: linux-m68k-owner@vger.kernel.org
To: linux-m68k@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Christian

Am 06.06.2017 um 07:17 schrieb Christian T. Steigies:
> On Mon, Jun 05, 2017 at 07:37:59PM +1200, Michael Schmitz wrote:
>> m68k_num_memory is unsuitable to test for the presence of FastRAM
>> on CT60 if the kernel is located in FastRAM: in arch/m68k/mm/motorola.c
>> the ST-RAM chunk is skipped and m68k_num_memory is decremented in this
>> case. m68k_realnum_memory still contains the actual number of RAM chunks
>> so use that.
>>
>> Tested by Christian Steiges on his Falcon with kernel loaded in FastRAM
>> - could you please reply with your Tested-by tag, Christian?
> 
> Sure, do I need to sign it or is this ok?
> 
> Tested-by: Christian T. Steigies <cts@debian.org>
>> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

That's OK - we know it was you :-)

Martin has already applied it - thanks!

Cheers,

	Michael
