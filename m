From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [BUG] Linux-2.6.31-rc1-git9 Cannot Recognize Empty DVD Media
Date: Wed, 08 Jul 2009 18:52:55 -0400
Message-ID: <yq1my7eg52w.fsf@sermon.lab.mkp.net>
References: <4A4CB4B4.5010307@turknet.net.tr>
	<20090702130728.22af524c.akpm@linux-foundation.org>
	<8db1092f0907080609w60e37ac0id49a44bd4796b425@mail.gmail.com>
	<1247063244.4159.40.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:22372 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbZGHWxa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2009 18:53:30 -0400
In-Reply-To: <1247063244.4159.40.camel@mulgrave.site> (James Bottomley's
	message of "Wed, 08 Jul 2009 09:27:24 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tarkan Erimer <tarkan.erimer@turknet.net.tr>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> You might also try this patch from martin petersen: it will print
James> out the actual command that's causing the problems ... that might
James> give a clue.

Any particular reason you didn't merge that patch, btw.?  It's been
extremely useful on this end...

-- 
Martin K. Petersen	Oracle Linux Engineering

