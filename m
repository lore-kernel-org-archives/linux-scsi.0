From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 0/3] debloat aic7xxx and aic79xx drivers
Date: Fri, 31 Aug 2007 22:20:36 +0100
Message-ID: <200708312220.36818.vda.linux@googlemail.com>
References: <200708311613.59666.vda.linux@googlemail.com> <31870.1188577642@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:35352 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887AbXHaVUz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Aug 2007 17:20:55 -0400
Received: by nf-out-0910.google.com with SMTP id f5so799547nfh
        for <linux-scsi@vger.kernel.org>; Fri, 31 Aug 2007 14:20:53 -0700 (PDT)
In-Reply-To: <31870.1188577642@turing-police.cc.vt.edu>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Cc: Hannes Reinecke <hare@suse.de>, Jan Engelhardt <jengelh@computergmbh.de>, Matthew Wilcox <matthew@wil.cx>, Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Friday 31 August 2007 17:27, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 31 Aug 2007 16:13:59 BST, Denys Vlasenko said:
> >
> >    text    data     bss     dec     hex filename
> >  261433   50018    1172  312623   4c52f linux-2.6.23-rc1.org.t/drivers/scsi/aic7xxx/built-in.o
> >  199654   50018    1172  250844   3d3dc linux-2.6.23-rc1.aic.t/drivers/scsi/aic7xxx/built-in.o
> >  184014   21314    1172  206500   326a4 linux-2.6.23-rc1.aic1.t/drivers/scsi/aic7xxx/built-in.o
> >  202378    2850    1172  206400   32640 linux-2.6.23-rc1.aic2.t/drivers/scsi/aic7xxx/built-in.o
> > 
> > 1-debloat.patch    deinlines a lot of functions
> > 2-addstatic.patch  adds statics, #ifdefs out huge amount of unused code, adds consts
> > 3-addconst.patch   adds more consts
> 
> Yowza.  Looking at aic1->aic2, it looks like 20K became 'const', and only
> 3K *wasn't* 'const'?  

Exactly. There are firmware images/patches and a lot of structures
with char* members pointing to text/messages.

Btw, aic94xx driver needs the same treatment.
--
vda
