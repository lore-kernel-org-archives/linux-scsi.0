From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] drivers/scsi/advansys.c: fix advansys_board_found compile error
Date: Wed, 1 Aug 2007 07:55:15 -0600
Message-ID: <20070801135515.GV21219@parisc-linux.org>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <46B0842D.3060703@googlemail.com> <20070801133912.GA11027@kernel.sg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33537 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbXHANzR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 09:55:17 -0400
Content-Disposition: inline
In-Reply-To: <20070801133912.GA11027@kernel.sg>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: Gabriel C <nix.or.die@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Aug 01, 2007 at 09:39:12PM +0800, Eugene Teo wrote:
> This patch fixes the following compile error:
> 
> drivers/scsi/advansys.c: In function 'advansys_board_found':
> drivers/scsi/advansys.c:17781: error: implicit declaration of function
> 'to_pci_dev'

Or just remove the ifdefs around the include ... which is done in this
patch:

http://www.kernel.org/pub/linux/kernel/people/willy/advansys-2007-07-30/0001-advansys-version-copyright-etc.txt

I'd be interested in seeing the results of the randconfig trials on the
driver with those 23 patches applied, but not particularly interested in
the intermediate result.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
