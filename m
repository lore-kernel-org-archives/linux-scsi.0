From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 5/6] bfa: Brocade BFA FC SCSI driver submission (2ndtry)
Date: Fri, 26 Sep 2008 08:50:49 -0700
Message-ID: <1222444249.3971.4.camel@localhost.localdomain>
References: <200809260106.m8Q160kj028501@swe37.brocade.com>
	 <20080926025514.GD9480@kroah.com>
	 <4C94DE2070B172459E4F1EE14BD2364E01F28079@HQ-EXCH-5.corp.brocade.com>
	 <1222408937.3265.17.camel@localhost.localdomain>
	 <4C94DE2070B172459E4F1EE14BD2364E01F280A3@HQ-EXCH-5.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50065 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642AbYIZPvX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2008 11:51:23 -0400
In-Reply-To: <4C94DE2070B172459E4F1EE14BD2364E01F280A3@HQ-EXCH-5.corp.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@Brocade.COM>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, "Srikanth Rayas (CW)" <srayas@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>

On Thu, 2008-09-25 at 23:30 -0700, Jing Huang wrote:
> It is encouraging to know that we can discuss and add new feature into
> existing fc transport. I guess this is opensource all about. I didn't
> have linux opensource experience before, so I was not quite sure how
> easy to request new features in fc transport such as mechanism to create
> multiple subdirectories for different level of statistics info in
> addition to the snia fc statitistics we already have, and other features
> such as CT/SCSI passthru and asynchronous event notification etc.

Well, this is open source ... you don't get to request new features; you
get to implement them, so if you need something that SCSI or the FC
transport doesn't provide, you just add it (rather than coding either a
fix or an enhancement for your driver alone).

However, you're quite lucky.  So far, as James Smart said, I haven't
seen you ask for any features that we don't either provide or are in
process of agreeing the implementation of.

James


