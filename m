From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Tue, 24 Aug 2010 08:56:43 -0600
Message-ID: <20100824145643.GR12892@parisc-linux.org>
References: <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com> <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net> <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn> <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de> <1282256949.30453.278.camel@haakon2.linux-iscsi.org> <4C701E08.2020005@vlnb.net> <1282423398.3015.39.camel@mulgrave.site> <4C73DA15.2010207@vlnb.net> <AANLkTi=m15OJg+QsM76r1O74OWjdxht3tqza1DYEeLVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:34989 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab0HXO4o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2010 10:56:44 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTi=m15OJg+QsM76r1O74OWjdxht3tqza1DYEeLVw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Weiss <cweiss@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>

On Tue, Aug 24, 2010 at 09:51:04AM -0500, Chris Weiss wrote:
> ok now I'm confused, or maybe I'm not understanding ABI correctly, or
> maybe you guys are using it in a way that is inconsistent with popular
> convention.   As a VMware user, I have experienced fully that the
> kernel ABI changes in various places with every release.  VMwares
> drivers have to be constantly updated to match changes in kernel
> function parameters and even what functions are available.

You're talking about in-kernel ABI, which is constantly in flux.  James
is talking about user <-> kernel ABI, which is not supposed to change in
an incompatible way.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
