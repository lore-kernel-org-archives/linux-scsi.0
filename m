From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: scsi device refcounting in sbp2
Date: Sun, 11 Sep 2005 02:24:56 +0200
Message-ID: <43237958.6030106@s5r6.in-berlin.de>
References: <200509102116.j8ALGqt8011874@einhorn.in-berlin.de> <1126392585.4813.79.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:63637 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932727AbVIKAZK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2005 20:25:10 -0400
In-Reply-To: <1126392585.4813.79.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Ben Collins <bcollins@debian.org>

James Bottomley wrote:
> ... and you also know that the user has requested an ejection if
> you get a slave_destroy() call on it.

Thanks for the clarification and suggestions. I'll try and see what 
works best.
-- 
Stefan Richter
-=====-=-=-= =--= -=-==
http://arcgraph.de/sr/
