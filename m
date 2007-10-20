From: Mattia Dongili <malattia@linux.it>
Subject: oops in lbmIODone, fails to boot [Re: 2.6.23-mm1]
Date: Sat, 20 Oct 2007 13:57:54 +0900
Message-ID: <20071020045753.GA4660@inferi.kami.home>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfbichi11.ns.itscom.net ([219.110.2.189]:52574 "EHLO
	mfbichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbXJTOXO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Oct 2007 10:23:14 -0400
Content-Disposition: inline
In-Reply-To: <20071011213126.cf92efb7.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Oct 11, 2007 at 09:31:26PM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/

Hey there!!
fails to boot here with this friendly oops:
http://oioio.altervista.org/linux/dsc01702.jpg

.config: http://oioio.altervista.org/linux/config-2.6.23-mm1-1

2.6.23-rc8-mm2 booted ok but had other problems I haven't reported yet
(no s2ram with mysql running and some net WARNING).
Let's see if .23-mm1 still has those first.

I'm adding Cc: linux-scsi

PS: I'll hardly be able to bisect in the next days... :P
-- 
mattia
:wq!
