From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] dc395x - 1/3 remove-static-eeprom-struct
Date: 03 Aug 2003 10:01:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1059922898.10960.3.camel@mulgrave>
References: <20030803082718.GA4594@twibble.org>
	<20030803082759.GA4611@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:24068 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S271199AbTHCPBr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Aug 2003 11:01:47 -0400
In-Reply-To: <20030803082759.GA4611@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lenehan <lenehan@twibble.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, dc395x@twibble.org

On Sun, 2003-08-03 at 03:27, Jamie Lenehan wrote:
> Move the eeprom details from a static struct indexed by adapter
> number into the adapter information block of the adapter. This
> removes the fixed size static array and removes the need to count the
> number of adapters.

This patch is rejecting fairly comprehensively against the dc395x driver
in the tree, could you rediff against either 2.6.0-test2 or the
bitkeeper scsi-misc-2.5 tree?

Thanks,

James


