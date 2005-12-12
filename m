From: Michael Reed <mdr@sgi.com>
Subject: Re: how to tell a WWN of FC HBA under linux
Date: Mon, 12 Dec 2005 14:54:44 -0600
Message-ID: <439DE394.4070505@sgi.com>
References: <1134413431.10254.91.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:58829 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S1751256AbVLLUys (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2005 15:54:48 -0500
In-Reply-To: <1134413431.10254.91.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mingz@ele.uri.edu
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Look in /sys/class/fc_host/hostX for
entries port_name and node_name.  Most
but not all fc drivers implement this.
Others may export data in /proc or provide
their own utility to get it.

Mike


Ming Zhang wrote:
> Hi folks
> 
> I know it is possible that tell the WWN during post. But is it possible
> to tell under linux after system boots?
> 
> Thanks!
> 
> Ming
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
