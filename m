From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 0/2] struct scsi_lun preparation
Date: Tue, 12 Sep 2006 12:33:58 -0700 (PDT)
Message-ID: <20060912193358.31647.qmail@web31806.mail.mud.yahoo.com>
References: <4505D81F.5020300@garzik.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31806.mail.mud.yahoo.com ([68.142.207.69]:6233 "HELO
	web31806.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1030377AbWILTd6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Sep 2006 15:33:58 -0400
In-Reply-To: <4505D81F.5020300@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, "Moore, Eric" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

--- Jeff Garzik <jeff@garzik.org> wrote:
> Moore, Eric wrote:
> > On Monday, September 11, 2006 1:56 PM, Jeff Garzik wrote: 
> > 
> >>> A pretty print for the current u32 would be very useful though for
> >>> transports dealing with non single level luns (or address 
> >> methods other
> >>> than zero).
> >> A better subject line would have been "HCIL isolation" I suppose.  I 
> >> would like to see increased usage of the accessors already present in 
> >> include/scsi/scsi_device.h, which would ease the transition from 
> >> hardcoded HCIL struct members to a more flexible addressing method.
> >>
> >> Though, FWIW, for LUNs I would certainly like to see u64 rather than 
> >> u32.....
> >>
> > 
> > shouldn't luns be defined as: 
> > 
> > u8 lun[8] instead of u64?  
> 
> Please, not that argument again :)
> 
> It's purely semantics, the same storage is used, and only very rarely 
> are the contents actually examined in either case.

After a while, those little things, "purely semantics" as you called
them, _accrue_ to produce the ''architecture'' of the subject matter.

As they say, "The devil is in the details."

Good luck!
       Luben

