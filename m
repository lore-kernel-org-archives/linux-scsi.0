From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Wed, 25 Aug 2010 18:20:26 -0400
Message-ID: <201008251820.27293.konrad@darnok.org>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com> <4C73DA15.2010207@vlnb.net> <AANLkTi=m15OJg+QsM76r1O74OWjdxht3tqza1DYEeLVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:35871 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab0HYWVc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Aug 2010 18:21:32 -0400
In-Reply-To: <AANLkTi=m15OJg+QsM76r1O74OWjdxht3tqza1DYEeLVw@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Weiss <cweiss@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>

On Tuesday 24 August 2010 10:51:04 Chris Weiss wrote:
> On Tue, Aug 24, 2010 at 9:41 AM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> > James Bottomley, on 08/22/2010 12:43 AM wrote:
> >> Interface re-use (or at least ABI compatibility) is the whole point,
> >> it's what makes the solution a drop in replacement.
> >
> > I see now. You want ABI compatibility to keep the "contract" that no
> > kernel changes can break applications binary compatibility for unlimited
> > time.
>
> ok now I'm confused, or maybe I'm not understanding ABI correctly, or
> maybe you guys are using it in a way that is inconsistent with popular

You are thinking of the KABI. That changes per each release except if you buy 
a vendor product. Red Hat for example keeps an KABI symbol list where they 
guarantee that those parameters, structures ,etc will never change. John 
Masters wrote a nice paper about how they solved this:
http://dup.et.redhat.com/presentations/DriverUpdateProgramTechnical.pdf

I don't have experience with other vendors.

In terms of ABI, think ioctl calls and its a parameters. They are suppose to 
stay the same for long long durations.

> convention.   As a VMware user, I have experienced fully that the
> kernel ABI changes in various places with every release.  VMwares
> drivers have to be constantly updated to match changes in kernel
> function parameters and even what functions are available.
>
> I've also experienced it with scsi cards, dsl modems, and other 3rd
> party drivers.  It's the one big downside to developing for the Linux
> kernel, the ABI is /always/ changing.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


