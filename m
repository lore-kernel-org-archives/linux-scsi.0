From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/5] Use msleep() instead of schedule_timeout
Date: Tue, 08 Dec 2009 15:53:29 -0600
Message-ID: <1260309210.4147.46.camel@mulgrave.site>
References: <20091208213514.23493.86458.stgit@beardog.cce.hp.com>
	 <20091208213812.23493.20587.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293AbZLHVxb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2009 16:53:31 -0500
In-Reply-To: <20091208213812.23493.20587.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, smcameron@yahoo.com

On Tue, 2009-12-08 at 15:38 -0600, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> Use msleep() instead of schedule_timeout
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This looks great.

However, to push it as part of SCSI I now need a from scratch patch to
add to scsi-misc, please ...

James


