From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: Wed, 29 Oct 2003 13:45:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067453148.3112.369.camel@compaq.xsintricity.com>
References: <1067447221.3112.336.camel@compaq.xsintricity.com>
	 <1067447490.1829.30.camel@mulgrave>
	 <20031029175045.GC25237@parcelfarce.linux.theplanet.co.uk>
	 <1067450547.3112.363.camel@compaq.xsintricity.com>
	 <20031029183159.GE25237@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:24068 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261276AbTJ2Sqp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 13:46:45 -0500
In-Reply-To: <20031029183159.GE25237@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Wed, 2003-10-29 at 13:31, Matthew Wilcox wrote:

> Ahhh.  Then I'm misusing it.  We haven't sent an INQUIRY to the drive
> at this point, so of course it will be zero.  Some more pondering required.

Yeah, the appropriate time to check that bit would be at
slave_configure() time.  (Hmmm...I should have documented that...)

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


