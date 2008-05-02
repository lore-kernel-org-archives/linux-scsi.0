From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 06/10] scsi_dh: Do not allow arguments for
	hardware handlers
Date: Fri, 2 May 2008 23:47:31 +0100
Message-ID: <20080502224731.GH18935@agk.fab.redhat.com>
References: <20080501214941.27759.95121.sendpatchset@chandra-ubuntu>
	<20080501215017.27759.37314.sendpatchset@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080501215017.27759.37314.sendpatchset@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, asson_ronald@emc.com, James.Bottomley@HansenPartnership.com, dm-devel@redhat.com, Benoit_Arthur@emc.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Thu, May 01, 2008 at 02:50:17PM -0700, Chandra Seetharaman wrote:
> Subject: [PATCH 06/10] scsi_dh: Do not allow arguments for hardware handlers
> From: Chandra Seetharaman <sekharan@us.ibm.com>
> The new implementation does not use the arguments provided with the
> hardware handler. This patch makes the change visible to the user by
> failing table load when arguments are provided with the hardware handler.
 
But then someone supplying such an arg may need to update their
userspace multipath config file before they can use this new kernel.

Past experience suggests that changes like that usually come back
and bite us.  Let's instead just have the kernel log a message noting
that the args have been ignored and allow people to deal with it at
their leisure.

Alasdair
-- 
agk@redhat.com
