From: Ali Akcaagac <aliakc@web.de>
Subject: Re: [Dc395x] Re: [PATCH] dc395x - 1/3 remove-static-eeprom-struct
Date: Sun, 03 Aug 2003 17:04:08 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1059923048.5692.1.camel@localhost>
References: <20030803082718.GA4594@twibble.org>
	 <20030803082759.GA4611@twibble.org>  <1059922898.10960.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp01.web.de ([217.72.192.180]:63512 "EHLO smtp.web.de")
	by vger.kernel.org with ESMTP id S271211AbTHCPF1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2003 11:05:27 -0400
In-Reply-To: <1059922898.10960.3.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jamie Lenehan <lenehan@twibble.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2003-08-03 at 17:01, James Bottomley wrote:
> This patch is rejecting fairly comprehensively against the dc395x driver
> in the tree, could you rediff against either 2.6.0-test2 or the
> bitkeeper scsi-misc-2.5 tree?

Works pretty nice for me agains 2.6.0-test2-bk2. There are around 2800
lines of changes between 2.6.0-test2 and 2.6.0-test2-bk2 so it's most
likely that this fails. Use the BK2 version please. Works like a charm
here.

