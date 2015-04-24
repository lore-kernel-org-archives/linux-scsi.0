From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH V2 0/7] be2iscsi driver update to 10.6.0.0
Date: Fri, 24 Apr 2015 08:23:22 -0500
Message-ID: <D6D5009E-1AD2-4EE6-B866-44B7E734ABB3@cs.wisc.edu>
References: <f80de952-8450-451e-a62f-ae6baf931c6e@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54827 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbbDXNXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2015 09:23:32 -0400
In-Reply-To: <f80de952-8450-451e-a62f-ae6baf931c6e@CMEXHTCAS2.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@emulex.com>
Cc: linux-scsi@vger.kernel.org


On Apr 24, 2015, at 9:46 PM, John Soni Jose <sony.john-n@emulex.com> wrote:

> The patchset updates be2iscsi driver to 10.6.0.0 version.
> These patches are generated aganist scsi for-next branch
> 
> John Soni Jose (7):
>  be2iscsi : Fix the retry count for boot targets
>  be2iscsi : Fix the PCI request region reserving.
>  be2iscsi : Fix memory leak in the unload path
>  be2iscsi : Fix memory check before unmapping.
>  be2iscsi : Update the copyright year
>  be2iscsi : Logout of FW Boot Session
>  be2iscsi : Bump the driver version
> 
> drivers/scsi/be2iscsi/be.h       |    2 +-
> drivers/scsi/be2iscsi/be_cmds.c  |    6 ++-
> drivers/scsi/be2iscsi/be_cmds.h  |   14 ++++++-
> drivers/scsi/be2iscsi/be_iscsi.c |    2 +-
> drivers/scsi/be2iscsi/be_iscsi.h |    2 +-
> drivers/scsi/be2iscsi/be_main.c  |   78 +++++++++++++++++++++++++++++--------
> drivers/scsi/be2iscsi/be_main.h  |    8 +++-
> drivers/scsi/be2iscsi/be_mgmt.c  |   71 ++++++++++++++++++++++++++++++++++-
> drivers/scsi/be2iscsi/be_mgmt.h  |    5 ++-
> 9 files changed, 162 insertions(+), 26 deletions(-)
> 

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>