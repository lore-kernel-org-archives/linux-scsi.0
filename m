From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] 2.4.27-pre2: another loss of SCSI I/O initiative and system freeze
Date: Wed, 5 May 2004 07:43:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040505054349.GB1315@suse.de>
References: <OFA9ADACA9.EF1DD108-ONC1256E8A.005FBA48-C1256E8A.0063BC83@de.ibm.com> <1083717070.2942.5207.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:56768 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262337AbUEEFoI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2004 01:44:08 -0400
Content-Disposition: inline
In-Reply-To: <1083717070.2942.5207.camel@compaq.xsintricity.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Martin Peschke3 <MPESCHKE@de.ibm.com>, Marcelo Tosatti <marcelo.tosatti@cyclades.com>, linux-scsi mailing list <linux-scsi@vger.kernel.org>, andmike@us.ibm.com, garloff@suse.de

On Tue, May 04 2004, Doug Ledford wrote:
> On Tue, 2004-05-04 at 14:04, Martin Peschke3 wrote:
> > 
> > 
> > Marcelo, Doug,
> > 
> > Please consider the following patch for inclusion. It fixes a severe
> > loss-of-initiative SCSI problem that can cause a system freeze.
> 
> Marcelo, I have no objection to this, but I haven't personally verified
> it either (and my bk trees are out of date so integrating it yourself is
> probably quickest).

It's really a slight API change, not a SCSI change per se. It's fine to
apply.

-- 
Jens Axboe

