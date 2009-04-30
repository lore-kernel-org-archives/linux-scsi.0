From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [GIT PATCH] block,scsi,ide: unify sector and data_len
Date: Thu, 30 Apr 2009 18:07:09 +0200
Message-ID: <200904301807.10302.bzolnier@gmail.com>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:51502 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbZD3QCg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2009 12:02:36 -0400
In-Reply-To: <1240996428-10159-1-git-send-email-tj@kernel.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com

On Wednesday 29 April 2009 11:13:38 Tejun Heo wrote:

[...]

> As the patchset contains several block-ide sync points, I think it's
> best to apply this series in unified series.  SCSI also received good
> amount of changes.  If there's a tree I can pull from which won't be
> rebased, please let me know.  If SCSI tree is gonna pull block tree
> after merge, that will be fine too.
> 
> All changed llds have been compile tested, mid-high layer resid_len
> handling has been verified and nothing broke during my test runs with
> ide and libata.

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

on drivers/ide parts and block ones (FWIW)
