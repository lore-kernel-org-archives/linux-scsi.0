From: Douglas Gilbert <dougg@torque.net>
Subject: Re: 2.5.22 scsi compile error
Date: Mon, 17 Jun 2002 09:16:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D0DE132.B583D0F6@torque.net>
References: <200206171755.18256.corporal_pisang@counter-strike.com.my>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Corporal Pisang <corporal_pisang@counter-strike.com.my>
Cc: linux-scsi@vger.kernel.org

Corporal Pisang wrote:
> 
> Hi,
> 
> I get this error compiling 2.5.22
> 
> make[2]: Entering directory `/usr/src/linux/drivers/scsi'
> make[2]: *** No rule to make target `constants.h', needed by `scsi.o'.  Stop.
> make[2]: Leaving directory `/usr/src/linux/drivers/scsi'
> make[1]: *** [scsi] Error 2
> make[1]: Leaving directory `/usr/src/linux/drivers'
> make: *** [drivers] Error 2

The header constants.h was removed in 2.5.22 (as its declarations
were already in scsi.h). [constants.c has been updated as well
and now other subsystems access it.]

When header files are removed or renamed you often need to do
a "make mrproper" before your normal kernel build. Don't forget
to keep a copy of your ".config" file before executing
"make mrproper".

lk 2.5.22 builds ok for me.

Doug Gilbert
