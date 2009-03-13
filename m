From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] hpsa: addressing review comments
Date: Fri, 13 Mar 2009 09:24:56 -0500
Message-ID: <1236954296.3276.14.camel@localhost.localdomain>
References: <20090313142054.GB15269@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57165 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbZCMOY7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Mar 2009 10:24:59 -0400
In-Reply-To: <20090313142054.GB15269@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: LKML-SCSI <linux-scsi@vger.kernel.org>

On Fri, 2009-03-13 at 09:20 -0500, Mike Miller (OS Dev) wrote:
> sorry, I fat fingered the address first time around...
> 
> Date: Fri, 13 Mar 2009 09:18:49 -0500
> From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
> To: LKML <linux-kernel@vger.kernel.org>, lkml-scis@beardog.cca.cpqcorp.net
> Cc: Steve Cameron <scameron@beardog.cca.cpqcorp.net>, tom.lawler@hp.com,
> 	iss_storagedev@hp.com
> Subject: [RFC] hpsa: addressing review comments
> 
> I have a question about the hpsa driver we recently released. We've received
> quite a few comments, very positive overall. When we make the changes noted,
> i.e., rip out /proc, style changes, etc., do we submit patches for that? Or
> repost the entire driver with the appropriate changelog?

Either is fine with me.  Posting update patches is very useful to people
who want to see what changes have been made between versions.  When we
iterate to a final version, then you can repost the whole thing (so it
can go into the tree as one to avoid bisection problems).

James


