From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH 00/33] bfa: Brocade BFA FC SCSI driver v2.3.2.0
 submission.
Date: Thu, 16 Sep 2010 13:47:17 -0400
Message-ID: <1284659237.26423.31.camel@mulgrave.site>
References: <1284576649-12684-1-git-send-email-kgudipat@brocade.com>
	 <4C92254D.7030304@redhat.com>
	 <5EB1A55E180C914BBC1A49310B7629386690401D4B@HQ1-EXCH02.corp.brocade.com>
	 <1284647663.4603.16.camel@mulgrave.site>
	 <5EB1A55E180C914BBC1A49310B7629386690401E0C@HQ1-EXCH02.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab0IPRrW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 13:47:22 -0400
In-Reply-To: <5EB1A55E180C914BBC1A49310B7629386690401E0C@HQ1-EXCH02.corp.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krishna Gudipati <kgudipat@Brocade.com>
Cc: Rob Evers <revers@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jing Huang <huangj@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Akshay Mathur <amathur@brocade.com>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>

On Thu, 2010-09-16 at 10:42 -0700, Krishna Gudipati wrote:
> Regarding the patch 1/33 should I send this patch 1 again by breaking it into two parts?
> Or is it ok since you have a reference to it already?

It looks like I have to apply this patch set as a single commit, so the
how doesn't matter much to me.  However, for the sake of others who want
to look at it on linux-scsi, I think you can just split it in half so we
get the full reviewable patch set (say 1a and 1b/33 ... that will
confuse the automated tools ...)

James


