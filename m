From: "Smitha Narayanaswamy \(smithan\)" <smithan@cisco.com>
Subject: RE: [linux-iscsi-devel] [PATCH] iSCSI transport class
Date: Wed, 10 Nov 2004 19:47:27 +0530
Message-ID: <026501c4c730$023fa6a0$6f074d0a@apac.cisco.com>
References: <41823426.5090007@cs.wisc.edu>
Reply-To: <smithan@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:32325 "EHLO
	sj-iport-5.cisco.com") by vger.kernel.org with ESMTP
	id S261893AbUKJORh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 09:17:37 -0500
In-Reply-To: <41823426.5090007@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mike Christie' <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-iscsi-devel@lists.sourceforge.net, duane.grigsby@qlogic.com, 'James Dykman' <dykman@us.ibm.com>

I think the patch looks fine.

Thanks,
Smitha

> -----Original Message-----
> From: linux-iscsi-devel-admin@lists.sourceforge.net
> [mailto:linux-iscsi-devel-admin@lists.sourceforge.net] On
> Behalf Of Mike Christie
> Sent: Friday, October 29, 2004 5:45 PM
> To: linux-scsi@vger.kernel.org;
> linux-iscsi-devel@lists.sourceforge.net;
> duane.grigsby@qlogic.com; James Dykman
> Subject: [linux-iscsi-devel] [PATCH] iSCSI transport class
>
>
> The attached patch adds an iSCSI transport class. It was
> built against scsi-misc-2.6. It allows the software/virtual
> iSCSI driver to remove at least one of its ioctl commands.
> The patch also assumes the no multipath/failover rule in
> llds applies to iSCSI drivers, so when we remove our
> portal/portal_group failover support it will allow us to
> kill all our ioctl commands execpt the session creation one
> (that will take more thought).
>
> We would like to build some functions like the
> unblock/block capabilites into the iscsi transport class
> like James Smart has done with FC class. but initially we
> would like to begin with this smaller patch that only provides
> an iscsi sysfs interface.
>
> Comments? Suggestions?
>
> I put some patches to convert our driver here
> http://www.cs.wisc.edu/~michaelc/iscsi/sysfs/
> if you want to test the class out. Those patches
> were made against the current linux-iscsi cvs tree.
>
> Mike Christie
>


