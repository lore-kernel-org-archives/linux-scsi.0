From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 3/7] block: push down BKL into .open and .release
Date: Thu, 8 Jul 2010 13:59:10 +0200
Message-ID: <201007081359.10760.arnd@arndb.de>
References: <1278514289-21054-1-git-send-email-arnd@arndb.de> <1278514289-21054-4-git-send-email-arnd@arndb.de> <4C358F29.4020505@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:55459 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab0GHL7P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 07:59:15 -0400
In-Reply-To: <4C358F29.4020505@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org

On Thursday 08 July 2010, Jens Axboe wrote:
> This is missing an smp_lock.h include in i2o as well.
> You seem to only add these sporadically, I think that
> is a bit unsafe since you are relying on unknown
> include hierarchies. That tends to break on one arch
> or config even if it works in another.

The i2o driver is the only one missing smp_lock.h, same problem
as the one you mentioned for patch 2/7. In v3 of the series it
was still correct, I broke it when I rushed out v4.

	Arnd
