From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 15:45:07 +0000
Message-ID: <20070312154507.69863c4c@lxorguk.ukuu.org.uk>
References: <45F48809.2060908@emc.com>
	<Pine.LNX.4.61.0703120013340.18623@yvahk01.tjqt.qr>
	<45F56589.1020209@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45F56589.1020209@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Ric Wheeler <ric@emc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> For 1K/4K logical sector sizes, who knows.  EFI?  <grins and runs>
> Certainly seems incompatible with the current popular DOS partition format.

Its a bit messier than that. There are two interpretations of "DOS"
partition formats found on 2K sector size magneto opticals. One is that
everything is the same as before (as if sectors were 512 byte), the other
is a different "everything is the same" which scales by the 2K sector
size. The two are of course wonderfully incompatible
