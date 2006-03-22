From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Compaq Fiber Channel Array RM4000 / Scsi middle ware driver
Date: Wed, 22 Mar 2006 13:02:29 -0700
Message-ID: <20060322200229.GT8980@parisc-linux.org>
References: <Pine.GSO.4.64.0602250050410.27649@filebunker.xip.at> <Pine.GSO.4.64.0602280120290.25994@filebunker.xip.at> <Pine.GSO.4.64.0602280130320.25994@filebunker.xip.at> <20060228004043.GH27759@parisc-linux.org> <Pine.GSO.4.64.0603221911370.14214@filebunker.xip.at> <yq1lkv2iap8.fsf@wilson.lab.mkp.net> <Pine.GSO.4.64.0603222054520.14214@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:28870 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750782AbWCVUCa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 15:02:30 -0500
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.0603222054520.14214@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: "Martin K. Petersen" <mkp@mkp.net>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, mark@markschaefer.org

On Wed, Mar 22, 2006 at 08:58:32PM +0100, Ingo Flaschberger wrote:
> Hi Martin,
> 
> >Ingo> The only modifications are in: drivers/scsi/scsi_scan.c
> >Ingo> modification of the lun search code
> >
> >Very cool!
> >
> >Do you support both PDA and VSA?
> 
> What is PDA and VSA?
> 
> And.. have some more probs (was a little bit too fast), perhaps you have 
> an idea:
> When I dd more than 556k bytes to the drive, I get errors.
> I have attached a log, some ideas would be great.

If you sent the patch, it might help people have ideas about what might
be wrong with it.
