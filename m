From: Hanna Linder <hannal@us.ibm.com>
Subject: Re: more aic7xxx boot failure
Date: Thu, 24 Oct 2002 16:12:23 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <16660000.1035501142@w-hlinder>
References: <8800000.1035498319@w-hlinder> <87lm4nxxnj.fsf@ceramic.fifi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <87lm4nxxnj.fsf@ceramic.fifi.org>
Content-Disposition: inline
To: Philippe Troin <phil@fifi.org>
Cc: Hanna Linder <hannal@us.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, tmolina@cox.net, haveblue@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

--On Thursday, October 24, 2002 15:46:56 -0700 Philippe Troin <phil@fifi.org> wrote:

> 
> Have you tried booting with "noapic"?

	Just did, That solves the problem too.

 
> What error do you get on boot?

a kernel panic and scsi_abort error 0x2 (from what
I remember flying by)

Would have to hookup with a serial cable to get all
the data. Here is what I can see on the screen:

LASTPHASE = 0x1, SCSISIGI = 0x0, SXFRCTL0 = 0x0
SSTAT0 = 0x0, SSTAT1 = 0x8
STACK == 0x17, 0x0, 0x0, 0x0
SCB count = 4
Kernel NEXQSCB = 3
Card NEXTQSCB = 0
QINFIFO entries: 3 2
a list of Waiting Queue entries 
and a list of Disconnected Queue entries.
QUOTFIFI entries:
Sequencer Free SCB List: 0 to 31
Pending list: 2
Kernel Free SCB list: 1 0
Untagged Q(0): 2
DevQ(0:0:0):0 waiting
qinpos = 0, SCB index = 3
Kernel panic: Loop 1


Hanna
