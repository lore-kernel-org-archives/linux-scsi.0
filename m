From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [Dc395x] Re: [PATCH] dc395x - 1/3 remove-static-eeprom-struct
Date: 03 Aug 2003 10:13:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1059923631.10853.6.camel@mulgrave>
References: <20030803082718.GA4594@twibble.org>
	<20030803082759.GA4611@twibble.org>  <1059922898.10960.3.camel@mulgrave>
	<1059923048.5692.1.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:30468 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S271206AbTHCPNz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Aug 2003 11:13:55 -0400
In-Reply-To: <1059923048.5692.1.camel@localhost>
List-Id: linux-scsi@vger.kernel.org
To: Ali Akcaagac <aliakc@web.de>
Cc: Jamie Lenehan <lenehan@twibble.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2003-08-03 at 10:04, Ali Akcaagac wrote:
> Works pretty nice for me agains 2.6.0-test2-bk2. There are around 2800
> lines of changes between 2.6.0-test2 and 2.6.0-test2-bk2 so it's most
> likely that this fails. Use the BK2 version please. Works like a charm
> here.

Ah, OK, the driver's coming through the -ac tree.  OK, I'll revert the
current change I have in the scsi tree from you so as not to damage the
merge.

James


