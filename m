From: Christoph Hellwig <hch@infradead.org>
Subject: Re: About ARECA RAID driver for Linux i386/x86-64
Date: Sun, 6 Feb 2005 14:50:01 +0000
Message-ID: <20050206145001.GB834@infradead.org>
References: <003f01c509a9$87913290$9300a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:22700 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261178AbVBFOuH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Feb 2005 09:50:07 -0500
Content-Disposition: inline
In-Reply-To: <003f01c509a9$87913290$9300a8c0@erich2003>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: erich <erich@areca.com.tw>
Cc: Linux Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Thu, Feb 03, 2005 at 12:33:37PM +0800, erich wrote:
> Hi,Andrew Morton
> 
> Thanks for your doing.
> ARECA Linux RAID driver need to support old linux kerenel version.
> There are a lot of  NAS RAID STORAGE SYSTEM development worker still use it
> at old linux kernel.
> Maybe I need to released one package that as cleanly as look like a Linux
> driver :) modern times :( .

If you write two proper drivers for 2.4.x and 2.6.x they're probably
less size than your current driver.

