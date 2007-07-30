From: Pete Wyckoff <pw@osc.edu>
Subject: [ofa-general] Announcing new open source iSER (iSCSI/RDMA) target
Date: Mon, 30 Jul 2007 14:23:40 -0400
Message-ID: <20070730182340.GI12789@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <general-bounces@lists.openfabrics.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: stgt-devel@lists.berlios.de, linux-scsi@vger.kernel.org, general@lists.openfabrics.org, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

We are releasing code to add support for iSCSI Extensions for RDMA
(iSER) to the existing STGT user space SCSI target.  It uses
OpenFabrics libraries and kernel drivers to act as a SCSI target
over RDMA-capable devices.  The code has been tested against
the existing Linux iSER initiator over InfiniBand cards, but
should be specification compliant and work generally.

A bit of documentation is included, and a short technical report is
available at http://www.osc.edu/~pw/papers/iser-techreport.pdf .
For performance, a single SCSI client using iSCSI over gigabit
ethernet does 100 MB/s.  iSCSI over IPoIB gets 200 MB/s, and iSER
over native IB sees 500 MB/s.

More information on STGT is available at http://stgt.berlios.de .

The seven iSER patches can be downloaded from:

	git://git.osc.edu/tgt

or browsed at:

	http://git.osc.edu/?p=tgt.git;a=summary

New and modified files are distributed under a GPLv2 license.  I'll
submit individual patches to stgt-devel for review and eventual
inclusion in STGT.

		-- Pete
