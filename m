From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [iscsi 2/2] iscsi-probe.c
Date: Wed, 24 Sep 2003 14:48:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030924144817.A16189@infradead.org>
References: <20030924133716.B14318@infradead.org> <016901c382a1$aadc5da0$8f074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:43015 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261362AbTIXNs0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 09:48:26 -0400
Content-Disposition: inline
In-Reply-To: <016901c382a1$aadc5da0$8f074d0a@apac.cisco.com>; from smhatre@cisco.com on Wed, Sep 24, 2003 at 07:12:12PM +0530
List-Id: linux-scsi@vger.kernel.org
To: "Sachin Mhatre (smhatre)" <smhatre@cisco.com>
Cc: 'Jeff Garzik' <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On Wed, Sep 24, 2003 at 07:12:12PM +0530, Sachin Mhatre (smhatre) wrote:
> Hi,
> 	The linux-iscsi source code submitted for review is for
> inclusion into the 2.4 linux kernel tree. You can get this source code
> from the linux-iscsi sourceforge branch with the tag
> "linux-iscsi-3-5-branch". Just for convenience here is the cvs command
> for anonymous checkout of this code:-
> cvs -d:pserver:anonymous@cvs.sourceforge.net:/cvsroot/linux-iscsi co -r
> linux-iscsi-3-5-branch linux-iscsi .
> 
> We have tested this code on the Redhat Linux 9.0 platform, kernel
> version 2.4.22.
> 
> Please let your valuable feedback pour in.

It looks like all comments I posted on linux-scsi apply to the
inux-iscsi-3-5-branch version of iscsi-probe.c, too.  So please
stop messing randomly with the namespace and opening files from
kernelspace, respect Documentation/CodingStyle (avoid typedefs,
linebreaks after 80 chars, etc..) and try to use kernel functionality
where available.

Note that I can't help you with redhat inclusion, but for mainline
inclusion we'd like to see a 2.6 version before a 2.4 one.  So my
advice would be to concentrate on 2.6 first, the scsi layer is much
nicer anyway there.  If that's done backport it to 2.4 which might
require a few bad workarounds and/or small changes to the scsi core.

