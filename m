From: Ali Akcaagac <aliakc@web.de>
Subject: Re: [Dc395x] Re: [PATCH] dc395x - 1/3 remove-static-eeprom-struct
Date: Tue, 12 Aug 2003 06:12:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060661529.2750.1.camel@localhost>
References: <20030803082718.GA4594@twibble.org>
	 <20030803082759.GA4611@twibble.org>  <1059922898.10960.3.camel@mulgrave>
	 <1059923048.5692.1.camel@localhost>  <1059923631.10853.6.camel@mulgrave>
	 <1059924971.5837.5.camel@localhost>  <1059932143.10853.112.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp02.web.de ([217.72.192.151]:50970 "EHLO smtp.web.de")
	by vger.kernel.org with ESMTP id S275003AbTHLEM3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Aug 2003 00:12:29 -0400
In-Reply-To: <1059932143.10853.112.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jamie Lenehan <lenehan@twibble.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2003-08-03 at 19:31, James Bottomley wrote:
> That's not actually possible for me: the -bkX snapshots aren't tagged in
> the main BK tree.  However, as long as no further updates are coming
> from elsewhere, the tree head is usually "good enough" to apply patches
> to.
> 
> In this case, it looks like with the exclusion I can apply to the tree
> head, so I'll merge the scsi-misc-2.5 repository up there.

Can you now please include the 3 new patches in the test3 ? As long as
no one contributes other patches it's the chance to do it.

http://www.twibble.org/dist/dc395x/2.05/

01-03 should fit on bk3 w/o problems.

