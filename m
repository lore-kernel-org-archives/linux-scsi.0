From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: use_10_for_ms revisited?
Date: 29 Jun 2003 11:31:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056882715.16249.0.camel@dhcp22.swansea.linux.org.uk>
References: <3EFE8784.4000101@pobox.com>
	 <20030628233824.H26995@one-eyed-alien.net> <3EFE8B7B.2000109@pobox.com>
	 <20030628235413.I26995@one-eyed-alien.net>  <3EFE94EA.7030909@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:29836
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S265619AbTF2KUd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 06:20:33 -0400
In-Reply-To: <3EFE94EA.7030909@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Sul, 2003-06-29 at 08:27, Jeff Garzik wrote:
> Really, sr wants to know "are you mmc-compliant?"
> 
> If the answer is yes, it should only use MMC-defined commands (mode 
> sense 10, etc.).
> 
> use_10_for_ms is a subset of that.

sr wants to know "are you mmc compliant or one of the odd list". The
scsi blacklist can handle them with luck

