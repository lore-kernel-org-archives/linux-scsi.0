From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain
Date: Fri, 11 Apr 2003 08:28:32 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200304110928.32978.pbadari@us.ibm.com>
References: <200304101339.49895.pbadari@us.ibm.com> <XFMail.20030411100430.pochini@shiny.it> <20030411154450.GW31739@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20030411154450.GW31739@ca-server1.us.oracle.com>
To: Joel Becker <Joel.Becker@oracle.com>, Giuliano Pochini <pochini@shiny.it>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Friday 11 April 2003 08:44 am, Joel Becker wrote:
> On Fri, Apr 11, 2003 at 10:04:30AM +0200, Giuliano Pochini wrote:
> > 4000 discs should be enough for anyone :)
> > Are >16 partitions/disc possible ?
> >
> 	>16 partitions/disc is possible once you remove Linux's
>
> arbitrary limit.
> 	4000 disks is today.  8000 disks is next year at the latest.

Well !! My patch does not have anything hardcoded to 4000.
Depends on how many minor bits. But we have to put a hardlimit
somewhere ..

> Just imagine multipathing today's 4000 disks.

Fortunately, the multipath solution Mike Anderson & Patrick Mansfield
working on, colapses all the disks you see thro multiple paths into 
number of  realdisks (4000). So you don't really need extra devices 
to support multipathing.

Thanks,
Badari
