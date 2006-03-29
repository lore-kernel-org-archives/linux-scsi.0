From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Compaq Fiber Channel Array RM4000 / Kernel implementation
Date: Wed, 29 Mar 2006 16:07:29 +0100
Message-ID: <20060329150729.GA14690@infradead.org>
References: <20060228004043.GH27759@parisc-linux.org> <Pine.GSO.4.64.0603221911370.14214@filebunker.xip.at> <yq1lkv2iap8.fsf@wilson.lab.mkp.net> <Pine.GSO.4.64.0603222054520.14214@filebunker.xip.at> <20060322200229.GT8980@parisc-linux.org> <Pine.GSO.4.64.0603222105560.14214@filebunker.xip.at> <Pine.GSO.4.64.0603282134370.8439@filebunker.xip.at> <yq18xqtain6.fsf@wilson.lab.mkp.net> <Pine.GSO.4.64.0603291305590.4009@filebunker.xip.at> <Pine.GSO.4.64.0603291428590.4009@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50820 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750792AbWC2PHa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 10:07:30 -0500
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.0603291428590.4009@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Mar 29, 2006 at 03:10:52PM +0200, Ingo Flaschberger wrote:
> Hello,
> 
> I have now got the RM4000 finally running.
> Following things I changed in the kernel:
> *) To find the devive:
> 	Lun scan code in scsi_scan.c
> 	Device special flags in scsi_devinfo.c
> 	The final implementation could be easy done via the flags in the
> 	scsi_devinfo.c file.
> 
> *) The RM4000 make troubles when trying to write more than 1023Kbytes in
> 	one cdb.
> 	I have changed sd.c to avoid this and only use 512Kbyte blocks as
> 	maximum.
> 	The final implementation is a little bit difficult because I need
> 	some flags to detect the block size problem in sd.c, sd_init_command.
> 	Should I build the changed into sd.c?

should probaby be a devinfo blacklist flag + quirk in sd.c

