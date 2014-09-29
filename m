From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] be2iscsi: check ip buffer before copying
Date: Mon, 29 Sep 2014 12:06:50 -0700
Message-ID: <1412017610.6067.18.camel@jarvis.lan>
References: <1412016942-4759-1-git-send-email-michaelc@cs.wisc.edu>
	 <1412016942-4759-2-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59305 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753768AbaI2TGw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 15:06:52 -0400
In-Reply-To: <1412016942-4759-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Mon, 2014-09-29 at 13:55 -0500, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> Dan Carpenter found a issue where be2iscsi would copy the ip
> from userspace to the driver buffer before checking the len
> of the data being copied:
> http://marc.info/?l=linux-scsi&m=140982651504251&w=2
> 
> This patch just has us only copy what we the driver buffer
> can support.
> 
> Tested-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

This looks to be a long standing and potentially exploitable bug ...
does it need a cc to stable?

James


