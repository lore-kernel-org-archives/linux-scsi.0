From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 4/5] scsi: libsas: Drop SAS_DPRINTK() and revise logs
 levels
Date: Wed, 14 Nov 2018 08:39:04 -0800
Message-ID: <89e6bbe46d4fe804f884d7cf37303d43f577ad33.camel@perches.com>
References: <1542203269-174932-1-git-send-email-john.garry@huawei.com>
         <1542203269-174932-5-git-send-email-john.garry@huawei.com>
         <132ba0c903b36d85db30cfebf58fe1f4c3a7c05b.camel@perches.com>
         <6c453baa-71bb-5fe0-28a1-5af097f2e9ae@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6c453baa-71bb-5fe0-28a1-5af097f2e9ae@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: hare@suse.com, yanaijie@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2018-11-14 at 15:12 +0000, John Garry wrote:
> On 14/11/2018 14:53, Joe Perches wrote:
> > On Wed, 2018-11-14 at 21:47 +0800, John Garry wrote:
> > > Like sas_printk() did previously, SAS_DPRINTK() offers little value now
> > > that libsas logs already have the "sas" prefix through pr_fmt(fmt). So it
> > > can be dropped.
> > > 
> > > However, after reviewing some logs in libsas, it is noticed that debug
> > > level is too low in many instances.
> > > 
> > > So this change drops SAS_DPRINTK() and revises some logs to a more
> > > appropriate level. However many stay at debug level, although some
> > > are significantly promoted.
> > []
> > > All the pre-existing checkpatch errors for spanning messages across
> > > multiple lines are untouched.
> > 
> > I think coalescing would be useful.
> 
> Sorry, I missed that. Do you mean that we stop spanning strings over 
> multiple lines?

Yes.

> If yes, I tend to agree. It means we can grep for full strings vs just a 
> different checkpatch issue (>80 lines or spanning multiple lines)

checkpatch does not emit a warning when a string is the
last element of a line that is > 80 chars when the
string stats before position 79.
