From: =?iso-8859-1?Q?Thomas_Lang=E5s?= <tlan@stud.ntnu.no>
Subject: Re: Weird Qlogic 2200 FC HBA / CNSI G7324  problem
Date: Sat, 13 Jul 2002 01:13:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020713011343.B4734@stud.ntnu.no>
References: <20020712010844.A19115@stud.ntnu.no> <20020711164141.B8468@beaverton.ibm.com> <20020712024511.A15943@stud.ntnu.no> <20020712102334.A9789@stud.ntnu.no> <20020712111842.A12686@stud.ntnu.no> <20020712091603.A10141@beaverton.ibm.com>
Reply-To: linux-scsi@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from localhost (localhost [127.0.0.1])
	by due.stud.ntnu.no (Postfix) with ESMTP id 2C08712B394
	for <linux-scsi@vger.kernel.org>; Sat, 13 Jul 2002 01:13:44 +0200 (CEST)
Received: from puma.stud.ntnu.no (puma.stud.ntnu.no [129.241.56.183])
	by due.stud.ntnu.no (Postfix) with ESMTP id 678D912B07F
	for <linux-scsi@vger.kernel.org>; Sat, 13 Jul 2002 01:13:43 +0200 (CEST)
Received: (from tlan@localhost)
	by puma.stud.ntnu.no (8.11.6/8.10.0.Beta12) id g6CNDhk05150
	for linux-scsi@vger.kernel.org; Sat, 13 Jul 2002 01:13:43 +0200
Content-Disposition: inline
In-Reply-To: <20020712091603.A10141@beaverton.ibm.com>; from andmike@us.ibm.com on Fri, Jul 12, 2002 at 09:16:03AM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Mike Anderson:
> With this config option not selected non zero luns will not be probed. You
> can also pass max_scsi_luns on the command line without re-compiling your
> kernel. Someone from RedHat would be better to comment on the default
> selection, but as you will see if you review the archive of this mail list
> there have been passed issues of probing non-zero luns on older devices
> not included in the scsi devicelist, so defaulting to off is possibly a
> conservative selection.

Tried the max_scsi_luns=128 (which is max, right?) without luck, before
I recompiled the kernel with "Probe all SCSI LUNs" enabled.

-- 
Thomas
