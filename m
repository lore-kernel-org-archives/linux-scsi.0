From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: Re: [RFC] SCSI target for IBM Power5 LPAR
Date: Wed, 7 Sep 2005 07:45:04 -0500
Message-ID: <20050907124504.GA13614@cs.umn.edu>
References: <20050906212801.GB14057@cs.umn.edu> <20050907104932.GA14200@lst.de>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc64-dev-bounces@ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20050907104932.GA14200@lst.de>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc64-dev>,
	<mailto:linuxppc64-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc64-dev>
List-Post: <mailto:linuxppc64-dev@ozlabs.org>
List-Help: <mailto:linuxppc64-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc64-dev>,
	<mailto:linuxppc64-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc64-dev-bounces@ozlabs.org
Errors-To: linuxppc64-dev-bounces@ozlabs.org
To: Christoph Hellwig <hch@lst.de>, Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linuxppc64-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 07, 2005 at 12:49:32PM +0200, Christoph Hellwig wrote:
> On Tue, Sep 06, 2005 at 04:28:01PM -0500, Dave C Boutcher wrote:
> > This device driver provides the SCSI target side of the "virtual
> > SCSI" on IBM Power5 systems.  The initiator side has been in mainline
> > for a while now (drivers/scsi/ibmvscsi/ibmvscsi.c.)  Targets already
> > exist for AIX and OS/400.
> 
> Please try to integrate that with the generic scsi target framework at
> http://developer.berlios.de/projects/stgt/.

There hasn't been a lot of forward progress on stgt in over a year, and
there were some issues (lack of scatterlist support, synchronous and
serial command execution) that were an issue when last I looked.

Vlad, can you comment on the state of stgt and whether you see it
being ready for mainline any time soon?

-- 
Dave Boutcher
