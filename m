From: Jamie Lenehan <lenehan@twibble.org>
Subject: Re: [PATCH] dc395x [1/6] - make functions static
Date: Tue, 26 Aug 2003 21:22:35 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030826112235.GA8609@twibble.org>
References: <20030821101348.GA7570@twibble.org> <20030821101434.GB7570@twibble.org> <20030821114632.A9401@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:65446 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S263593AbTHZLWe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2003 07:22:34 -0400
Content-Disposition: inline
In-Reply-To: <20030821114632.A9401@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, dc395x@twibble.org

On Thu, Aug 21, 2003 at 11:46:32AM +0100, Christoph Hellwig wrote:
[...]
> the static belongs on the same line as the prototype.

Well... I disagree and there's no mention of it in CodingStyle... but
having said I don't actually care that much! I'll note it down in my
list to things to change. (I'd rather do it all at once if I'm going
to do it then one bit at a time and having a mix of styles.)

-- 
 Jamie Lenehan <lenehan@twibble.org>
