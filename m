From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Reselection (bug-2139)
Date: Mon, 12 Apr 2004 22:57:03 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0404122250200.28020-100000@poirot.grange>
References: <Pine.LNX.4.44.0404042319580.2249-200000@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:48524 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263084AbUDLU5p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Apr 2004 16:57:45 -0400
Received: from lyakh (helo=localhost)
	by poirot.grange with local-esmtp (Exim 3.35 #1 (Debian))
	id 1BD8UJ-0007Pd-00
	for <linux-scsi@vger.kernel.org>; Mon, 12 Apr 2004 22:57:03 +0200
In-Reply-To: <Pine.LNX.4.44.0404042319580.2249-200000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Not a reply, rather, a re-phrasing of the same question...

So, in my current understanding, the problem the above bug is triggering
on is when a SCSI-device (a disk) switches after a reselect directly to a
data-in phase. This behaviour represents a problem for the tmscsim driver
only when tags are used. Now, my question is - what is the correct action
in this case? Silently try to recover and go on with it, or abort the
command and disable tags, or...

Thanks
Guennadi
---
Guennadi Liakhovetski


