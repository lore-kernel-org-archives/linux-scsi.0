From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/7] block: BKL removal, version 4
Date: Wed, 7 Jul 2010 22:18:23 +0200
Message-ID: <201007072218.24013.arnd@arndb.de>
References: <1278514289-21054-1-git-send-email-arnd@arndb.de> <4C34D74A.4060308@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64816 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab0GGUSq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2010 16:18:46 -0400
In-Reply-To: <4C34D74A.4060308@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org

On Wednesday 07 July 2010 21:36:42 Jens Axboe wrote:
> I'll go over each one tomorrow and add the series.

Ok, thanks!

If it makes your life easier, feel free to get this series from

git pull git://git.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git block

	Arnd
