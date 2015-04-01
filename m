From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v1] ata: ahci_xgene: Add AHCI Support for second
 generation of APM X-Gene SoC
Date: Wed, 1 Apr 2015 12:31:16 -0400
Message-ID: <20150401163116.GT9974@htj.duckdns.org>
References: <1427899682-10912-1-git-send-email-stripathi@apm.com>
 <1427899682-10912-2-git-send-email-stripathi@apm.com>
 <20150401161336.GS9974@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150401161336.GS9974@htj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 01, 2015 at 12:13:36PM -0400, Tejun Heo wrote:
> > Signed-off-by : Suman Tripathi <stripathi@apm.com>
> 
> Applied to libata/for-4.1 w/ minor edit.

Reverted due to build failure from missing asm/cputype.h.  Suman,
you're the develper and familiar with how the prerequisite patches are
flowing where.  When sending patches to maintainers, please let them
know how to deal with your patches.  Having cross-tree dependencies
are fine, there are multiple ways to deal with that but please don't
just drop patches which will fail build and see what happens.  Please
help us do our job.

Thanks.

-- 
tejun
