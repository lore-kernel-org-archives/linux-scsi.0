From: Doug Maxey <dwm@enoyolf.org>
Subject: Re: [PATCH] qla4xxx: kconfig must select scsi_iscsi_attrs
Date: Sat, 12 Aug 2006 12:32:34 -0500
Message-ID: <20060812173234.173493@bebe.enoyolf.org>
References: <20060812001429.23423.29164.stgit@bebe.enoyolf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:21647 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S932576AbWHLRgy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Aug 2006 13:36:54 -0400
In-reply-to: <20060812001429.23423.29164.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org


eh, um, ok.  David beat me to the punch.  This has already been applied
to the b9-k code from ftp.qlogic.  So this patch should be dropped.

Me going away for a few hours sure got me out of sync. :p

++doug

On Fri, 11 Aug 2006 19:14:29 CDT, Doug Maxey wrote:
> From: Doug Maxey <dwm@enoyolf.org>
> 
> The qla4xxx driver depends on scsi_transport_iscsi.o which needs
> SCSI_ISCSI_ATRS selected.  Make it so when building qla4xxx.
> 

