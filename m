From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 7/9] exofs: mkexofs
Date: Tue, 06 Jan 2009 01:40:10 -0700
Message-ID: <20090106084010.GI3932@webber.adilger.int>
References: <4947BFAA.4030208@panasas.com> <4947CA5C.50104@panasas.com>
 <20081229121423.efde9d06.akpm@linux-foundation.org>
 <495B8D90.1090004@panasas.com> <1230739053.3408.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <1230739053.3408.74.camel@localhost.localdomain>
Content-disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Dec 31, 2008  15:57 +0000, James Bottomley wrote:
> I don't like it mainly because it's not truly a useful general framework
> for others to build on.  However, as argued above, there might not
> actually be such a useful framework, so as long as the only two
> consumers (you and Lustre) want an interface like this, I'll put it in.

To be clear - Lustre has nothing to do with T10-OSD interfaces.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

