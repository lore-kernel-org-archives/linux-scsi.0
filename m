From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain
Date: Fri, 11 Apr 2003 16:18:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030411231842.GA4917@ca-server1.us.oracle.com>
References: <200304101339.49895.pbadari@us.ibm.com> <XFMail.20030411100430.pochini@shiny.it> <20030411154450.GW31739@ca-server1.us.oracle.com> <200304110928.32978.pbadari@us.ibm.com> <20030411175736.GY31739@ca-server1.us.oracle.com> <20030411111232.A7756@beaverton.ibm.com> <20030411183543.GA31739@ca-server1.us.oracle.com> <20030411130407.A9302@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from inet-mail2.oracle.com ([148.87.2.202]:30185 "EHLO
	inet-mail2.oracle.com") by vger.kernel.org with ESMTP
	id S262578AbTDKXIj (for <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Apr 2003 19:08:39 -0400
Content-Disposition: inline
In-Reply-To: <20030411130407.A9302@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, Giuliano Pochini <pochini@shiny.it>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>

On Fri, Apr 11, 2003 at 01:04:07PM -0700, Patrick Mansfield wrote:
> If we had user scanning, and some sort of hotplug for targets coming and
> going, those be used to add and remove (or just fail) paths (at least for
> switch attached).

	That's the issue.  We need notification of add and remove, so we
don't find our multipathing hanging for 90s or more.  That's a big deal
to people, and it's a problem with the current md multipath.

Joel

-- 

 "I'm living so far beyond my income that we may almost be said
 to be living apart."
         - e e cummings

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
