From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Booting from or using a Compaq RA4100 Array
Date: Mon, 2 Jan 2006 16:18:44 +0000
Message-ID: <20060102161844.GA13904@infradead.org>
References: <1135801791.9541.12.camel@gateway.markschaefer.org> <200512290845.17192@bilbo.math.uni-mannheim.de> <62187.24.3.12.198.1135893081.squirrel@www.markschaefer.org> <200512292302.50743@bilbo.math.uni-mannheim.de> <yq1oe2y44bf.fsf@wilson.lab.mkp.net> <1136168563.3768.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:63915 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750798AbWABQSt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jan 2006 11:18:49 -0500
Content-Disposition: inline
In-Reply-To: <1136168563.3768.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Schaefer <mark@markschaefer.org>
Cc: "Martin K. Petersen" <mkp@mkp.net>, Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-scsi@vger.kernel.org

On Sun, Jan 01, 2006 at 09:22:43PM -0500, Mark Schaefer wrote:
> Martin,
> 
> 	I think I'm the one who would have to sign up for TYPE_RAID driver
> writing.  I'll probably need some pointers, and it won't be fast, but
> I've definitely got a carrot.  I think the last scsi-howto for
> programming was dealing with the 2.4 series.

I'd suggets copying sd.c and add the command translations the cpqfc driver
has been doing to sd_init_command.  After that works post the preliminary
results to this list ;-)

Later lots of unessecary bits can be removed from the driver and the
init_command can be rewritten to directly issue the proper commands instead
of crafting SPC command and then translating them.


