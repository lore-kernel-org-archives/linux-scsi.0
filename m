From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Wed, 06 Feb 2008 19:33:13 -0500
Message-ID: <47AA51C9.4040005@garzik.org>
References: <20080122151857.GA8680@ubuntu.domain> <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com> <4796BB5A.9090003@garzik.org> <6b2481670801230254i46e65652vb9139e2c136e4ce4@mail.gmail.com> <479727D5.8060901@garzik.org> <6b2481670801250843g73ff3a6aydb465a654f53ad9d@mail.gmail.com> <1201300769.3119.78.camel@localhost.localdomain> <20080127152733.GC21302@ubuntu.domain> <1201457626.3746.21.camel@localhost.localdomain> <20080205131920.GA7901@ubuntu.domain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33223 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761112AbYBGAdR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Feb 2008 19:33:17 -0500
In-Reply-To: <20080205131920.GA7901@ubuntu.domain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com, kewei@marvell.com

Ke Wei wrote:
> Added support for hotplug and wide port.
> 
> 
> Signed-off-by: Ke Wei <kewei@marvell.com>
> ---
>  drivers/scsi/mvsas.c |  445 ++++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 339 insertions(+), 106 deletions(-)

Technically speaking, everything is looking great so far.

We need to correct one process problem, and we should be able to get 
your work into the 'mvsas' branch of scsi-misc-2.6.git... and soon 
thereafter hopefully into the official upstream kernel.

The process problem is...  when making revisions, we need to get the 
full patch each time.  In this case, each patch should be diff'd against 
the current version in the 'mvsas' branch:  version 0.1.

The succession of emails would look like this:

Email #1:

	Subject: [PATCH] mvsas: make it work

	Convert the skeleton mvsas driver into a real, working
	driver.  Currently, the following works:

	SAS, SAS expanders, SAS wide ports
	SATA devices, SATAPI

	Signed-off-by: Ke Wei <kewei@marvell.com>


And then James, myself, other reviewers reply.  Or, you add some new 
features like hotplugging.

Each time, you must regenerate a full patch against the most git 
repository revision:

	If a previous patch of yours, version "0.2", has been applied
	to git, then you would create your patch against version 0.2.

	If a previous patch of yours has NOT yet been applied to git,
	then you would create your patch against version 0.1.

Thus, in this case, version 0.1 is in 'mvsas' branch, so your second 
email would then be

Email #2:

	Subject: [PATCH v2] mvsas: make it work

	Convert the skeleton mvsas driver into a real, working
	driver.  Currently, the following works:

	SAS, SAS expanders, SAS wide ports
	SATA devices, SATAPI

	Signed-off-by: Ke Wei <kewei@marvell.com>
	---
	Changes since last posting (version 0.2):
	- fix coding problem


And then you continue your work, and add another revision while everyone 
else is sleeping, the third email would look like:

Email #3:

	Subject: [PATCH v3] mvsas: make it work

	Convert the skeleton mvsas driver into a real, working
	driver.  Currently, the following works:

	SAS, SAS expanders, SAS wide ports
	SATA devices, SATAPI

	Signed-off-by: Ke Wei <kewei@marvell.com>
	---
	Changes since last posting (version 0.3):
	- add hotplug support
	- add wide port support

	Changes since last posting (version 0.2):
	- fix coding problem


Thus, you always create a patch against the most recent source code in 
the git repository.

It is common for patches to go through a few revisions on the mailing 
list, before it is applied to the git repository.

So anyway...  send a patch against the latest #mvsas (version 0.1), and 
that patch should go in rapidly.

Thanks!  And keep up the good work,

	Jeff



