From: Jamie Lenehan <lenehan@twibble.org>
Subject: Re: ANNOUNCE dc395x update [2.03]
Date: Tue, 13 May 2003 20:56:31 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030513105631.GA7907@twibble.org>
References: <20030423072737.GA5529@twibble.org> <20030513090535.GA5528@twibble.org> <20030513114856.A16295@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charon.twibble.org ([203.217.29.134]:45544 "EHLO
	egwene.twibble.org") by vger.kernel.org with ESMTP id S263455AbTEMKnt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2003 06:43:49 -0400
Content-Disposition: inline
In-Reply-To: <20030513114856.A16295@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: dc395x@twibble.org, linux-scsi@vger.kernel.org

On Tue, May 13, 2003 at 11:48:56AM +0100, Christoph Hellwig wrote:
> On Tue, May 13, 2003 at 07:05:35PM +1000, Jamie Lenehan wrote:
> >  - Cleanup function scope. Make everything except the module init
> >    functions static.
> 
> everything should be static, including module init functions.

Yeah. Turns out this is a comment error - the actual module init
functions are static.

Thanks.

-- 
 Jamie Lenehan              Work Phone: +61 3 9843 8817
 lenehan@twibble.org        Work Email: jamie.lenehan@activcard.com.au
