From: Benjamin Block <bblock@linux.ibm.com>
Subject: Re: [PATCH] scsi: replace GFP_ATOMIC with GFP_KERNEL for sdev
 allocation
Date: Wed, 20 Feb 2019 21:03:59 +0100
Message-ID: <20190220200359.GB3731@t480-pf1aa2c2>
References: <20190220184847.24640-1-bblock@linux.ibm.com>
 <1550689891.93548.31.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1550689891.93548.31.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Steffen Maier <maier@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 20, 2019 at 11:11:31AM -0800, Bart Van Assche wrote:
> On Wed, 2019-02-20 at 19:48 +0100, Benjamin Block wrote:
> > We had a test-report where, under memory pressure, adding LUNs to the
> > systems would fail (the tests add LUNs strictly in sequence):
> 
> Hi Benjamin,
> 
> There are two more instances of GFP_ATOMIC in scsi_scan.c. Have you verified
> whether or not it is safe to change these into GFP_KERNEL too?
> 

No, I was lazy, but I can take a look tomorrow and fix them up as well
if they are similar to scsi_alloc_sdev().

-- 
With Best Regards, Benjamin Block      /      Linux on IBM Z Kernel Development
IBM Systems & Technology Group   /  IBM Deutschland Research & Development GmbH
Vorsitz. AufsR.: Matthias Hartmann       /      Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
