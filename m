From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 0/4] dm-mpath: dynamic load balancers
Date: Fri, 12 Sep 2008 10:50:38 -0400 (EDT)
Message-ID: <20080912.105038.102581623.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, stefan.bader@canonical.com
List-Id: linux-scsi@vger.kernel.org

Hi,

The following patches add the following 2 dynamic load balancers
to request-based dm-multipath:
  o queue-length oriented dynamic load balancer, dm-queue-length.
  o service-time oriented dynamic load balancer, dm-service-time.

This patch-set is not ready for inclusion to the upstream kernel,
but I'm posting now to hear comments from multipath related people.
Any comments are welcome.

This patch-set can be applied on top of 2.6.27-rc6 + Alasdair's
linux-next patches below + request-based dm patches(*).
    dm-mpath-use-more-error-codes.patch
    dm-mpath-remove-is_active-from-struct-dm_path.patch

(*) http://lkml.org/lkml/2008/9/12/100


Summary of the patch-set:
  1/4: dm-mpath: add a path-selector interface
  2/4: dm-mpath: add queue-length oriented dynamic load balancer (dlb)
  3/4: dm-mpath: interface change for service-time oriented dlb
  4/4: dm-mpath: add service-time oriented dynamic load balancer (dlb)

Thanks,
Kiyoshi Ueda
