From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/2 v3] be2iscsi: Fix some error messages
Date: Sat, 13 Aug 2016 09:41:38 -0700
Message-ID: <1471106498.3467.19.camel@perches.com>
References: <4cd24bc3-7953-479a-1dbe-2aac9299ce13@wanadoo.fr>
	 <1471072824-1491-1-git-send-email-christophe.jaillet@wanadoo.fr>
	 <1471088144.3467.11.camel@perches.com>
	 <fdffed8e-d269-6519-437e-6f731dbb9c05@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fdffed8e-d269-6519-437e-6f731dbb9c05@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, jayamohan.kallickal@avagotech.com, jejb@linux.vnet.ibm.com, ketan.mukadam@avagotech.com, sony.john@avagotech.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2016-08-13 at 14:31 +0200, Christophe JAILLET wrote:
> Le 13/08/2016 à 13:35, Joe Perches a écrit :
> > > @@ -268,7 +268,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
> > >   				&nonemb_cmd.dma);
> > >   	if (nonemb_cmd.va == NULL) {
> > >   		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
> > > -			    "BM_%d : Failed to allocate memory for"
> > > +			    "BM_%d : Failed to allocate memory for "
> > >   			    "mgmt_invalidate_icds\n");
> > doesn't match commit log as no coalescing/concatenation
> > is done.
> > 
> > There are many of these.
> > 
> I have *only* fixed the one reported by checkpatch and left the others 
> unchanged.
> 
> My initial proposal was to fix incorrect strings, without modifying too 
> much the code. So I decided to do the minimum of changes.
> 
> Should I resubmitted with:
>     - all strings *in the patch* concatenated?
>     - all strings *in the file*" concatenated?

Hello Christophe

You don't _have_ to do anything.

I think the commit message is misleading.

You could submit another patch that does
the equivalent of:

$ ./scripts/checkpatch.pl --types=SPLIT_STRING --fix-inplace drivers/scsi/be2iscsi/be_main.c

with the appropriate commit message
