From: Andrew Morton <akpm@osdl.org>
Subject: Re: About ARECA RAID driver for Linux i386/x86-64
Date: Wed, 2 Feb 2005 20:51:41 -0800
Message-ID: <20050202205141.0c28faf4.akpm@osdl.org>
References: <003f01c509a9$87913290$9300a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from fw.osdl.org ([65.172.181.6]:3218 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262315AbVBCEvr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2005 23:51:47 -0500
In-Reply-To: <003f01c509a9$87913290$9300a8c0@erich2003>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: erich <erich@areca.com.tw>
Cc: linux-scsi@vger.kernel.org

"erich" <erich@areca.com.tw> wrote:
>
> Thanks for your doing.
>  ARECA Linux RAID driver need to support old linux kerenel version.
>  There are a lot of  NAS RAID STORAGE SYSTEM development worker still use it
>  at old linux kernel.

Well that's a decision which the scsi maintainers will need to make.  Lots
of current drivers use LINUX_VERSION_CODE, even though we'd prefer they not
do so.  I don't know what the scsi policy is for new submissions.


