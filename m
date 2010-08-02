From: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (scsi-post-merge tree related)
Date: Mon, 2 Aug 2010 15:59:40 -0400
Message-ID: <20100802195940.GC32503@andromeda.dapyr.net>
References: <20100803024445.0bf7ec86.sfr@canb.auug.org.au> <20100803024701.b3dff69a.sfr@canb.auug.org.au> <1280768048.2843.242.camel@mulgrave.site> <4C570464.9010204@cs.wisc.edu> <20100802185925.GA32503@andromeda.dapyr.net> <4C5717E6.8010805@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C5717E6.8010805@cs.wisc.edu>
Sender: linux-next-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Jayamohan Kallickal <jayamohank@serverengines.com>, Randy Dunlap <randy.dunlap@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> >Yikes. Last minute change, eh?
> 
> I do not know what you mean. The patches always had iscsi_boot_sysfs in 
> the firmware dir. You mean this is a last minute change?

Yes, this rename.
> 
> >
> >>interface is generic and should be used on any arch and with anything
> >>(ibft or iscsi driver) that wants to export iscsi boot info. The
> >>attached patch moves iscsi_boot_sysfs to drivers/scsi. It was made over
> >>linux-next. I have only compile tested it.
> >
> >did you compile test it with the x86 native iBFT driver?
> 
> Yes.

Excellent. The patch does not look like it has changed at all, so:

 1). Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
   for the removal from firmware/ibft, and
 2). Reviewed-by: Konrad Rzeszutek Wilk <konrad@kernel.org> for the
 the part that puts in drivers/scsi and will make it now under James'
 mainternship.

James,

I've asked Linus to pull my iBFT tree before yours as there was this
dependency. Are you OK putting this patch in your tree, or would you prefer
that I expunge Mike's patch from mine?


> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
