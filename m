From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] pm8001: enhance firmware event log retrieval
Date: Mon, 20 Feb 2012 10:43:25 -0600
Message-ID: <1329756205.2791.39.camel@dabdike.int.hansenpartnership.com>
References: <97204CD5-5C4D-4E62-ADD4-CE51AB11C460@xyratex.com>
	,  <1329578412.2862.24.camel@dabdike> <201202191454024304010@usish.com>
	 <8BB4E44E-AD13-48E8-BA20-A5AAF068E8C6@xyratex.com>
	 <95CA7344-D026-40CC-9A1E-176C632FC7E0@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53994 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752824Ab2BTQn1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2012 11:43:27 -0500
In-Reply-To: <95CA7344-D026-40CC-9A1E-176C632FC7E0@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@xyratex.com>
Cc: jack_wang <jack_wang@usish.com>, linux-scsi <linux-scsi@vger.kernel.org>, crystal_yu <crystal_yu@usish.com>, lindar_liu <lindar_liu@usish.com>

On Mon, 2012-02-20 at 11:31 -0500, Mark Salyzyn wrote:
> No testing, I agreed on the appearance, make excellent sense and can
> see no problem with it. I have NOT tested it (Xyratex has no interest
> in 32-bit systems, this turns into a one-of with no Q/A backing). I
> will put it in my own queue for testing and submit a fix if I feel it
> is necessary (my WAG on risk of that is 0.000234% ;-/ )

You don't need to test it on a 32 bit system ... just make sure that it
gives a correct log entry on a 64 bit one (i.e. that I got all the
factors correct).

James


