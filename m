From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fibre Channel state of the union
Date: Wed, 20 Apr 2005 23:51:22 +0100
Message-ID: <20050420225122.GA8292@infradead.org>
References: <48D2F90F2962FC48852540179EC444F605E699C0@tayexc18.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:9631 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261821AbVDTWvX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 18:51:23 -0400
Content-Disposition: inline
In-Reply-To: <48D2F90F2962FC48852540179EC444F605E699C0@tayexc18.americas.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bhat, Vinod" <vinod.bhat@hp.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Apr 20, 2005 at 02:43:23PM -0400, Bhat, Vinod wrote:
> Hi,
> 
> Here are few thoughts. On sourceforge there is a hbaapi project.
> http://sourceforge.net/projects/hbaapi/ This is old project. Is it
> possible to update that one or create a new project for hbaapi?

first major problem is that it's licensed under an SNIA opensource license
which it links to but doesn't exist anymore on their website.  To be
easily redistributable for Linux Distribution it should be licensed
under the LGPL or a BSDish license.

Also it contains lots of unessecary bloat like the dlopen-based plugin
loading and windows support that wouldn't be nessecary for something
that's simply a shim from the SNIA apis to the Linux native mechanisms.

> If we have a open source project and supported by major HBA vendors, we
> can build tools(open source) on this project. That will help bigger
> community. Here is the SN Ping and Traceroute project proposal. This is
> one example.
> 
> http://www.t11.org/ftp/t11/admin/project_proposals/05-225v0.pdf
> http://www.t11.org/ftp/t11/admin/project_proposals/05-177v1.txt 

These are good ideas for an fc-tools package or something like that.
I'd rather write them directly to native APIs instead of going through
the needless complication and obsfucations of the SNIA APIs.

