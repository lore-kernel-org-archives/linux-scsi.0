From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v1] ata: ahci_xgene: Add AHCI Support for second
 generation of APM X-Gene SoC
Date: Wed, 1 Apr 2015 12:47:48 -0400
Message-ID: <20150401164748.GU9974@htj.duckdns.org>
References: <1427899682-10912-1-git-send-email-stripathi@apm.com>
 <1427899682-10912-2-git-send-email-stripathi@apm.com>
 <20150401161336.GS9974@htj.duckdns.org>
 <20150401163116.GT9974@htj.duckdns.org>
 <20150401163956.GE24899@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:35896 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbbDAQrw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2015 12:47:52 -0400
Content-Disposition: inline
In-Reply-To: <20150401163956.GE24899@n2100.arm.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Suman Tripathi <stripathi@apm.com>, devicetree@vger.kernel.org, mlangsdo@redhat.com, arnd@arndb.de, linux-scsi@vger.kernel.org, jcm@redhat.com, patches@apm.com, linux-ide@vger.kernel.org, olof@lixom.net, linux-arm-kernel@lists.infradead.org

On Wed, Apr 01, 2015 at 05:39:56PM +0100, Russell King - ARM Linux wrote:
> On Wed, Apr 01, 2015 at 12:31:16PM -0400, Tejun Heo wrote:
> > On Wed, Apr 01, 2015 at 12:13:36PM -0400, Tejun Heo wrote:
> > > > Signed-off-by : Suman Tripathi <stripathi@apm.com>
> > > 
> > > Applied to libata/for-4.1 w/ minor edit.
> > 
> > Reverted due to build failure from missing asm/cputype.h.
> 
> I'm guessing this is some kind of ARM driver, which is why
> linux-arm-kernel has been Cc'd - though I haven't seen the original
> patch.

It's ahci_xgene which seems to be specific to ARM.

> ARM has asm/cputype.h, and has had for a long time, so "missing
> asm/cputype.h" doesn't make sense as a reason to revert it.  Maybe

As it's a new build failure I assumed that was a new file.  Apparently
not.

> it's trying to be built on x86 when it should be restricted to
> only ARM?

The build failure is from kbuild and it's on PPC64 w/ COMPILE_TEST.
Urgh.. Suman, can you please update the patch to turn off COMPILE_TEST
on the driver?

Thanks.

-- 
tejun
