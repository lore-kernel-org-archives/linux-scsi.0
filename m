From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: how to tell a WWN of FC HBA under linux
Date: Mon, 12 Dec 2005 17:00:51 -0500
Message-ID: <1134424851.10254.134.camel@localhost.localdomain>
References: <1134413431.10254.91.camel@localhost.localdomain>
	 <439DE394.4070505@sgi.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orca.ele.uri.edu ([131.128.51.63]:44194 "EHLO orca.ele.uri.edu")
	by vger.kernel.org with ESMTP id S932086AbVLLWBA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2005 17:01:00 -0500
In-Reply-To: <439DE394.4070505@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Thanks a lot! I found it for qla2300.

Ming

On Mon, 2005-12-12 at 14:54 -0600, Michael Reed wrote:
> Look in /sys/class/fc_host/hostX for
> entries port_name and node_name.  Most
> but not all fc drivers implement this.
> Others may export data in /proc or provide
> their own utility to get it.
> 
> Mike
> 
> 
> Ming Zhang wrote:
> > Hi folks
> > 
> > I know it is possible that tell the WWN during post. But is it possible
> > to tell under linux after system boots?
> > 
> > Thanks!
> > 
> > Ming
> > 
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 

