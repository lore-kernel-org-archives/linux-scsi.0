From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Fri, 18 Jul 2003 09:30:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030718093006.5e07b6e2.akpm@osdl.org>
References: <20030716132036.GB833@suse.de>
	<1058364455.1856.28.camel@mulgrave>
	<20030716
	170456.GK833@suse.de>
	<20030717015756.135a3f5a.akpm@osdl.org>
	<2003071708595
	2.GX833@suse.de>
	<3F1672D9.7070309@cyberone.com.au>
	<20030717102926.GE833@su
	se.de>
	<3F167F98.60006@cyberone.com.au>
	<20030717105641.GF833@suse.de>
	<3F16
	83F5.4030107@cyberone.com.au>
	<20030717111059.GI833@suse.de>
	<3F168846.90902
	@cyberone.com.au>
	<1058474814.4638.11.camel@markh1.pdx.osdl.net>
	<1058481553
	.19508.5.camel@markh1.pdx.osdl.net>
	<1058485621.7424.30.camel@dell_ss5.pdx.o
	sdl.net>
	<20030717170055.5dbe20c1.akpm@osdl.org>
	<3F17821A.307@cyberone.com.
	au>
	<20030717222534.0295c44e.akpm@osdl.org>
	<3F1785D9.5000905@cyberone.com.au>
	<1058537776.1863.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:63430 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S268548AbTGRQWk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 12:22:40 -0400
In-Reply-To: <1058537776.1863.6.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: piggin@cyberone.com.au, daniel@osdl.org, markh@osdl.org, axboe@suse.de, cliffw@osdl.org, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> On Fri, 2003-07-18 at 00:30, Nick Piggin wrote:
> > No, I think Mark's last patch with Daniel's and my suggestions
> > should be fine. It fixes their problems. Its unfortunate that
> > this bug never got caught until now but it was inevitable to be
> > one or two there.
> 
> Could you roll up all your AS changes and send them to this list as a
> single patch so I can test them out?

Nick is probably on a plane by now.  I sent Mark's original one-liner to
Linus last night.
