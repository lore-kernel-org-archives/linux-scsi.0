From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 7/9] scsi_dh: Add support for SDEV_PASSIVE
Date: Mon, 11 Feb 2008 10:27:46 -0800
Message-ID: <1202754466.13537.123.camel@linuxchandra>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
	<20080124003203.18871.52040.sendpatchset@localhost.localdomain>
	<1202151498.3096.84.camel@localhost.localdomain>
	<1202156151.13537.14.camel@linuxchandra>
	<1202156914.3096.112.camel@localhost.localdomain>
	<1202159970.13537.19.camel@linuxchandra>
	<20080209124511.GB28967@parisc-linux.org>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080209124511.GB28967@parisc-linux.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Matthew Wilcox <matthew@wil.cx>
Cc: Mike Anderson <andmike@us.ibm.com>, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, dm-devel@redhat.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Sat, 2008-02-09 at 05:45 -0700, Matthew Wilcox wrote:
> On Mon, Feb 04, 2008 at 01:19:30PM -0800, Chandra Seetharaman wrote:
> > The device does send these error messages currently, but it takes some
> > time to get the check condition back, which adds up the time to boot
> > especially when the # of LUNS is huge.
> > 
> > For example, in my test configuration, I had 40 luns, and the time
> > difference (with this patch and without it) to boot is 171 seconds and
> > 1426 seconds.
> 
> Was that with sync or async SCSI bus scanning?

I didn't change anything, IOW, i did default scanning, which I would
guess sync ?!


> 
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
