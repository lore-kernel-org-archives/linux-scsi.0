From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [Dc395x] Re: [PATCH] dc395x - 1/3 remove-static-eeprom-struct
Date: 03 Aug 2003 12:31:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1059932143.10853.112.camel@mulgrave>
References: <20030803082718.GA4594@twibble.org>
	<20030803082759.GA4611@twibble.org>  <1059922898.10960.3.camel@mulgrave>
	<1059923048.5692.1.camel@localhost>  <1059923631.10853.6.camel@mulgrave>
	<1059924971.5837.5.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:9732 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S270848AbTHCRgT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Aug 2003 13:36:19 -0400
In-Reply-To: <1059924971.5837.5.camel@localhost>
List-Id: linux-scsi@vger.kernel.org
To: Ali Akcaagac <aliakc@web.de>
Cc: Jamie Lenehan <lenehan@twibble.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2003-08-03 at 10:36, Ali Akcaagac wrote:
> So if possible please add these 3 patches ontop of what's inside bk2,
> this will save us a lot of pain :)

That's not actually possible for me: the -bkX snapshots aren't tagged in
the main BK tree.  However, as long as no further updates are coming
from elsewhere, the tree head is usually "good enough" to apply patches
to.

In this case, it looks like with the exclusion I can apply to the tree
head, so I'll merge the scsi-misc-2.5 repository up there.

James



