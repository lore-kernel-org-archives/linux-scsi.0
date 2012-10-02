From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [PATCH][SCSI] mpt3sas: Paer 1 of MPI API headers
Date: Tue, 2 Oct 2012 20:49:52 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A60A50578D7F@inbmail02.lsi.com>
References: <20120929140743.GA20622@localhost.localdomain>
 <878vbsy2jg.fsf@nemi.mork.no> <20120930015027.GA28918@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:36929 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754344Ab2JBPUE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2012 11:20:04 -0400
In-Reply-To: <20120930015027.GA28918@parisc-linux.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Bj??rn Mork <bjorn@mork.no>
Cc: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@kernel.org" <jejb@kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Sat, Sep 29, 2012 at 10:52:50PM +0200, Bj??rn Mork wrote:
> <sreekanth.reddy@lsi.com> writes:
> > > This patch contains MPI API headers
> > 
> > Why can't this and the other headers be shared between the mpt2sas and
> > mpt3sas drivers?  Looks like you are duplicating a lot of code already
> > present in drivers/scsi/mpt2sas.  Why?  That's a recipe for maintenance
> > hell...
>
> I would go further and ask why this needs a new driver; why can't mpt2sas
> be enhanced to drive the 12Gbit cards?

A deliberate choice was made to keep the mpt3sas separate from mpt2sas due to our 6 GIG product being truly mature with a noticeable ramping down of enhancements/releases.   

mpt3sas is at it's initial baseline with a healthy roadmap ahead.  Architecturally there will be changes to the headers that will be only mpt3sas specific. Another reason to keep the source separate.  

The mpt3sas release schedules is on a faster cadence than mpt2sas so keeping the source aligned is problematic.    

>From a maintenance and test perspective having the source base separate actually reduces the so called maintenance "hell".


-- 
Regards,
Nagalakshmi
