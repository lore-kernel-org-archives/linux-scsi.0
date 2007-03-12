From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 12:17:40 +0000
Message-ID: <20070312121740.3f0d13f9@lxorguk.ukuu.org.uk>
References: <45F48809.2060908@emc.com>
	<Pine.LNX.4.61.0703120013340.18623@yvahk01.tjqt.qr>
	<45F4BEC4.5090402@emc.com>
	<Pine.LNX.4.61.0703120423360.4339@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0703120423360.4339@yvahk01.tjqt.qr>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Ric Wheeler <ric@emc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> Now, if this disk was copied byte per byte (/bin/dd) to a
> 4096-based disk, and Linux would start using a sector size of
> 4096, then I would suddenly have

The ATA drives I'm aware of report 512 byte sector size, do 512 byte
I/O's but use 4K physical sectors and to get sane performance except the
OS to issue sensible sized I/O requests.
