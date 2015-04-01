From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v1] ata: ahci_xgene: Add AHCI Support for second
 generation of APM X-Gene SoC
Date: Wed, 1 Apr 2015 18:30:30 +0100
Message-ID: <20150401173029.GF24899@n2100.arm.linux.org.uk>
References: <1427899682-10912-1-git-send-email-stripathi@apm.com>
 <1427899682-10912-2-git-send-email-stripathi@apm.com>
 <20150401161336.GS9974@htj.duckdns.org>
 <20150401163116.GT9974@htj.duckdns.org>
 <20150401163956.GE24899@n2100.arm.linux.org.uk>
 <20150401170032.GC28616@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150401170032.GC28616@e104818-lin.cambridge.arm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Tejun Heo <tj@kernel.org>, devicetree@vger.kernel.org, mlangsdo@redhat.com, Suman Tripathi <stripathi@apm.com>, arnd@arndb.de, linux-scsi@vger.kernel.org, jcm@redhat.com, patches@apm.com, linux-ide@vger.kernel.org, olof@lixom.net, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 01, 2015 at 06:00:33PM +0100, Catalin Marinas wrote:
> On Wed, Apr 01, 2015 at 05:39:56PM +0100, Russell King - ARM Linux wrote:
> > On Wed, Apr 01, 2015 at 12:31:16PM -0400, Tejun Heo wrote:
> > > On Wed, Apr 01, 2015 at 12:13:36PM -0400, Tejun Heo wrote:
> > > > > Signed-off-by : Suman Tripathi <stripathi@apm.com>
> > > > 
> > > > Applied to libata/for-4.1 w/ minor edit.
> > > 
> > > Reverted due to build failure from missing asm/cputype.h.
> > 
> > I'm guessing this is some kind of ARM driver, which is why
> > linux-arm-kernel has been Cc'd - though I haven't seen the original
> > patch.
> > 
> > ARM has asm/cputype.h, and has had for a long time, so "missing
> > asm/cputype.h" doesn't make sense as a reason to revert it.  Maybe
> > it's trying to be built on x86 when it should be restricted to
> > only ARM?
> > 
> > Dunno without seeing the original patch.
> 
> First search result leads here:
> 
> https://www.mail-archive.com/devicetree@vger.kernel.org/msg67774.html

Thanks.

> The driver in general should not be ARM specific, though it runs on an
> ARMv8 platform. But looking at the patch it has some errata workarounds
> triggered based on the CPU id (MIDR). That looks dodgy as it doesn't
> even check the full ID, only the variant part.

Okay, it's not ARM but an ARM64 driver, so that's your territory, not
mine. :)

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
