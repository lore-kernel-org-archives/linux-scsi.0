From: mroos@linux.ee
Subject: Re: 3.4.0-02580-g72c04af regression on sparc64 - partitions not
 recognized
Date: Fri, 25 May 2012 10:55:24 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1205251053390.17096@math.ut.ee>
References: <alpine.SOC.1.00.1205221200050.9585@math.ut.ee>  <20120522.151217.278388169416093561.davem@davemloft.net>  <alpine.SOC.1.00.1205231945480.12326@math.ut.ee>  <20120523.140451.386112705611304887.davem@davemloft.net>
 <1337813770.3013.37.camel@dabdike.int.hansenpartnership.com> <1337826142.6877.7.camel@dwillia2-mobl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337826142.6877.7.camel@dwillia2-mobl>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: James Bottomley <jejbbe@hansenpartnership.com>, David Miller <davem@davemloft.net>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, stern@rowland.harvard.edu
List-Id: linux-scsi@vger.kernel.org

> ...so it seems scsi_complete_async_scans() should take care to flush sd
> probe actions as well... here is a test patch:

Just finished testing it against 3.4.0-05722-gf936991. Without the 
patch, this version fails to boot and with it, it boots fine. Now going 
to test your 4-patch series.

-- 
Meelis Roos (mroos@linux.ee)
