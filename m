From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain
Date: Fri, 11 Apr 2003 11:12:32 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030411111232.A7756@beaverton.ibm.com>
References: <200304101339.49895.pbadari@us.ibm.com> <XFMail.20030411100430.pochini@shiny.it> <20030411154450.GW31739@ca-server1.us.oracle.com> <200304110928.32978.pbadari@us.ibm.com> <20030411175736.GY31739@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030411175736.GY31739@ca-server1.us.oracle.com>; from Joel.Becker@oracle.com on Fri, Apr 11, 2003 at 10:57:37AM -0700
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, Giuliano Pochini <pochini@shiny.it>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 11, 2003 at 10:57:37AM -0700, Joel Becker wrote:

> > Fortunately, the multipath solution Mike Anderson & Patrick Mansfield
> > working on, colapses all the disks you see thro multiple paths into 
> > number of  realdisks (4000). So you don't really need extra devices 
> > to support multipathing.
> 
> 	Yes, but what if I want to see the multiple paths?  Does their
> solution allow you to specify the path behind the 'realdisk'?  Does it
> allow querying of the paths?
> 
> Joel

Seeing the path to disk relationship - yes (via proc for now, eventually
via sysfs).

Specifying from user space what path goes with what disk (explicitly): no,
that might require user level scanning.

Query a path - seeing and setting path states yes (via proc right now).
Using sg with a specified path - no, but on the TODO list.

I'm trying to pull the current multi-path patch up to 2.5.66 (ouch). 

The last functioning patch was against 2.5.59, some general info:

http://www-124.ibm.com/storageio/multipath/scsi-multipath/index.php

Or the patch:

http://www-124.ibm.com/storageio/multipath/scsi-multipath/releases/2.5.59-mpath-1.patch.gz

-- Patrick Mansfield
