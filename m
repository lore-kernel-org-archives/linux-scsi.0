From: Luben Tuikov <ltuikov@yahoo.com>
Subject: RE: [PATCH 0/2] struct scsi_lun preparation
Date: Tue, 12 Sep 2006 12:21:08 -0700 (PDT)
Message-ID: <20060912192108.16531.qmail@web31813.mail.mud.yahoo.com>
References: <664A4EBB07F29743873A87CF62C26D70307646@NAMAIL4.ad.lsil.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:34151 "HELO
	web31813.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1030361AbWILTVJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Sep 2006 15:21:09 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70307646@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

--- "Moore, Eric" <Eric.Moore@lsil.com> wrote:
> On Monday, September 11, 2006 1:56 PM, Jeff Garzik wrote: 
> 
> > > A pretty print for the current u32 would be very useful though for
> > > transports dealing with non single level luns (or address 
> > methods other
> > > than zero).
> > 
> > A better subject line would have been "HCIL isolation" I suppose.  I 
> > would like to see increased usage of the accessors already present in 
> > include/scsi/scsi_device.h, which would ease the transition from 
> > hardcoded HCIL struct members to a more flexible addressing method.
> > 
> > Though, FWIW, for LUNs I would certainly like to see u64 rather than 
> > u32.....
> > 
> 
> shouldn't luns be defined as: 
> 
> u8 lun[8] instead of u64?  
> 
> Luben?

Hi Eric,

Yes, you are absolutely correct, LUNs as well as SAS addresses,
are indeed u8[8], for well known reasons.

    Luben

