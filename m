From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [Patch 4/6] lpfc 8.3.5: Add AER support
Date: Wed, 7 Oct 2009 21:25:54 +0200
Message-ID: <20091007192554.GA1656@one.firstfloor.org>
References: <1254511016.32739.23.camel@ogier> <87r5tfzqpq.fsf@basil.nowhere.org> <412A05BA40734D4887DBC67661F43308101CA3F0@EXMAIL.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:55442 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759900AbZJGT0q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2009 15:26:46 -0400
Content-Disposition: inline
In-Reply-To: <412A05BA40734D4887DBC67661F43308101CA3F0@EXMAIL.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex.Iannicelli@Emulex.Com
Cc: andi@firstfloor.org, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Wed, Oct 07, 2009 at 08:27:28AM -0700, Alex.Iannicelli@Emulex.Com wrote:
> > James Smart <James.Smart@Emulex.Com> writes:
> > 
> > > This patch adds AER support.
> > 
> > I'm curious -- how did you test that? Did you use the new AER injector
> > in 2.6.31?
> 
> Yes, we tested it using all the AER error profiles in the AER injector tool.

If you wrote any special scripts it would be good if you could publish
those (ideally become part of aer-inject), so that others can later
test too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
