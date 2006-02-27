From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Export spi_populate_* functions
Date: Mon, 27 Feb 2006 15:31:38 +0100
Message-ID: <1141050699.2992.113.camel@laptopd505.fenrus.org>
References: <20060227141826.GB27759@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45441 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751250AbWB0Obn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2006 09:31:43 -0500
In-Reply-To: <20060227141826.GB27759@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-02-27 at 07:18 -0700, Matthew Wilcox wrote:
> These functions should be usable by modules.


since this is new and very much linux specific code, shouldn't these be
_GPL exports?

