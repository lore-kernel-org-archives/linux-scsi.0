From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: ybin on powerpc
Date: Mon, 21 Aug 2006 07:54:17 +1000
Message-ID: <1156110857.5803.82.camel@localhost.localdomain>
References: <20060819111919.a60dca49.akpm@osdl.org>
	 <1156024644.5803.73.camel@localhost.localdomain>
	 <20060819182818.bf3ff5bc.akpm@osdl.org>
	 <1156088355.3726.39.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:28305 "EHLO gate.crashing.org")
	by vger.kernel.org with ESMTP id S1751400AbWHTVys (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Aug 2006 17:54:48 -0400
In-Reply-To: <1156088355.3726.39.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>, linux-scsi@vger.kernel.org, Paul Nasrat <pnasrat@redhat.com>


> Well ... OK, we shouldn't break things gratuitously.  However,
> the /proc/scsi interface is deprecated and has been for a while now.
> 
> Secondly, as Matthew pointed out, the SCSI standards actually keep
> changing their minds about the names of these things ...
> 
> But, thirdly, in order to get around the issue, we provided the
> 
> /sys/class/scsi_disk/<x:y:z:i>/device/type
> 
> interface which supplies the numeric field value precisely so people
> shouldn't parse the translated strings.
> 
> So, it sounds like yaboot is also in need of modification.

CC'ed Paul Nasrat who is the current yaboot maintainer

(Paul, the problem is about a /proc/scsi change breaking ofpath. The
change will probably be reverted, but still, ofpath should be changed to
not rely on that crap anymore)

Cheers,
Ben.


