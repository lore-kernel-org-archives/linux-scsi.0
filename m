From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] procfs support for sgiwd93
Date: Mon, 17 Oct 2005 12:19:32 +0200
Message-ID: <1129544373.2907.18.camel@laptopd505.fenrus.org>
References: <20051015013824.GA25248@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43137 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932256AbVJQKTl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 06:19:41 -0400
In-Reply-To: <20051015013824.GA25248@linux-mips.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Sat, 2005-10-15 at 02:38 +0100, Ralf Baechle wrote:
> FYI and reviewing pleassure.
> 
> Author: Thiemo Seufer <ths@networkno.de>
> Date:   Tue Apr 12 14:00:38 2005 +0000
> 
> Enable proc support, minor code cleanup.

isn't this the wrong way around; eg afaik we're deprecating proc support
from LLDD's...



