From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ide-scsi changes for new mid level api and error
	handling in 2.5.52
Date: 25 Dec 2002 21:30:41 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1040851841.1104.9.camel@dhcp22.swansea.linux.org.uk>
References: <Pine.LNX.4.10.10212231104020.19341-100000@master.linux-ide.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.10.10212231104020.19341-100000@master.linux-ide.org>
List-Id: linux-scsi@vger.kernel.org
To: Andre Hedrick <andre@linux-ide.org>
Cc: Willem Riede <wrlk@riede.org>, linux-scsi@vger.kernel.org

On Mon, 2002-12-23 at 19:05, Andre Hedrick wrote:
> 
> There are a few changes I have to fix the ordering of the driver for clean
> DMA ATAPI.  These are test on ia64 Itanium 2 from HP.

Actually the fixes from HP have been in the base 2.4 and 2.5 IDE for
several weeks

