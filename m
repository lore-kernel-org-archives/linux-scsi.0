From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: PATCH for g_NCR5380, DTC3151 support
Date: 02 Jan 2003 17:34:51 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1041528891.24830.10.camel@irongate.swansea.linux.org.uk>
References: <200301020830.h028UPV20703@atle.abc.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200301020830.h028UPV20703@atle.abc.se>
List-Id: linux-scsi@vger.kernel.org
To: Nils Hammar <m4341@abc.se>
Cc: linux-scsi@vger.kernel.org

On Thu, 2003-01-02 at 08:30, Nils Hammar wrote:
> 
> Patches for the g_NCR5380 driver.
> The current driver depends on the ISAPNP functionality, but not all
> computers have ISAPNP, like my old Compaq 386sx.

Why this huge patch.

Firstly ISAPnP is a fundamental ISA bus feature - so any box can support
it. Secondly I don't understand what your code changes are trying to
achieve because the diff is hard to follow

Other bits - why mdelay(100) not a sleeping timeout ?


The printk changes look fine, but the rest of it is a bit harder to
follow.

> Note: I couldn't find any maintainer for this driver in the
> MAINTAINERS file.

Thats sort of me. I've done major reworking on the 2.5 code and I keep
some eye on the 2.4 code too. 


