From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC PATCH 0/4] dm-mpath: dynamic load balancers
Date: Wed, 28 Jan 2009 15:37:04 +0000
Message-ID: <20090128153704.GA23158@agk.fab.redhat.com>
References: <20080912.105038.102581623.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080912.105038.102581623.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: j-nomura@ce.jp.nec.com, dm-devel@redhat.com, stefan.bader@canonical.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 12, 2008 at 10:50:38AM -0400, Kiyoshi Ueda wrote:
> The following patches add the following 2 dynamic load balancers
> to request-based dm-multipath:
>   o queue-length oriented dynamic load balancer, dm-queue-length.
>   o service-time oriented dynamic load balancer, dm-service-time.
 
Could we have separate Kconfig options to select them?

Alasdair
-- 
agk@redhat.com
