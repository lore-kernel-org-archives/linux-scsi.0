From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain
Date: Fri, 11 Apr 2003 08:44:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030411154450.GW31739@ca-server1.us.oracle.com>
References: <200304101339.49895.pbadari@us.ibm.com> <XFMail.20030411100430.pochini@shiny.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from inet-mail2.oracle.com ([148.87.2.202]:25239 "EHLO
	inet-mail2.oracle.com") by vger.kernel.org with ESMTP
	id S264386AbTDKPeN (for <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Apr 2003 11:34:13 -0400
Content-Disposition: inline
In-Reply-To: <XFMail.20030411100430.pochini@shiny.it>
List-Id: linux-scsi@vger.kernel.org
To: Giuliano Pochini <pochini@shiny.it>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Apr 11, 2003 at 10:04:30AM +0200, Giuliano Pochini wrote:
> 4000 discs should be enough for anyone :)
> Are >16 partitions/disc possible ?

	>16 partitions/disc is possible once you remove Linux's
arbitrary limit.
	4000 disks is today.  8000 disks is next year at the latest.
Just imagine multipathing today's 4000 disks.

Joel

-- 

"Well-timed silence hath more eloquence than speech."  
         - Martin Fraquhar Tupper

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
