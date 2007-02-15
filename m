From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: sg version 4 tools
Date: Fri, 16 Feb 2007 01:58:58 +0900 (JST)
Message-ID: <20070215085845L.fujita.tomonori@lab.ntt.co.jp>
References: <20070214153508Z.fujita.tomonori@lab.ntt.co.jp>
	<45D48990.70607@torque.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:64586 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030220AbXBOQ7G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Feb 2007 11:59:06 -0500
In-Reply-To: <45D48990.70607@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sg version 4 tools
Date: Thu, 15 Feb 2007 08:25:52 -0800

> FUJITA Tomonori wrote:
> > I created a git tree for makeshift sg version 4 tools:
> > 
> > http://www.kernel.org/git/?p=linux/kernel/git/tomo/sgv4-tools.git;a=summary

(snip)

> Tomo,
> Just a few points.
> 
> While the sgv4_dd command line interface (cli) looks
> sensible, it diverges from the dd command (which is
> non-unix like but reasonably "fit for service" for the
> function that dd performs). So even though the Unix dd
> command syntax takes a while to get used to, other testers
> will be most likely to be comfortable with existing dd syntax.

Yeah, probably. Patches are always welcome. :) It's just a simple tool
that I've used for development.


> In summary, I don't think that there needs to be a
> sg4_utils. As you suggest, sgv4_dd can be incorporated
> into the existing sg3_utils at a convenient time.
> sg v4 represents an alternate interface for a linux
> pass-through and the bulk of sg3_utils already supports
> 4 pass-throughs via a common code base. [The four are
> linux (sg v3), FreeBSD, Tru64, Windows (from NT forward).]

Agreed. Surely, I don't want to maintain sgv4_utils. I'm thinking
about keeping it until we finish some experiments on sgv4 interface
(like ring buffer).

If you add sgv4 support to sg3_utils now, I'm happy to remove the git
tree. :)
