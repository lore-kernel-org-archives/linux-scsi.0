From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] Sym. 53c895 fails accessing tape device - kernel
	2.9.1-rc1-bk1 trough rc2-bk12
Date: 02 Oct 2004 18:28:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096756118.4415.39.camel@mulgrave>
References: <13842.1096472870@www69.gmx.net>
	<1096732158.2169.13.camel@mulgrave>
	<Pine.LNX.4.58.0410022246140.1977@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-64-109-89-108.dsl.chcgil.ameritech.net ([64.109.89.108]:36483
	"EHLO redscar") by vger.kernel.org with ESMTP id S267571AbUJBW2k
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Oct 2004 18:28:40 -0400
In-Reply-To: <Pine.LNX.4.58.0410022246140.1977@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Alexander Stohr <Alexander.Stohr@gmx.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, matthew@wil.cx, akpm@digeo.com

On Sat, 2004-10-02 at 16:25, Kai Makisara wrote:
> I would like to have a little more details. In order to see this message, 
> the tape drive should have been in fixed block mode. By default dd uses 
> write() size of 512 bytes. The size of linux-2.6.8.tar.gz is 44678561 
> bytes. This is not divisible by 512 and this means that the last write of 
> dd is not 512 bytes and the write fails in foxed block mode (it fails in 
> my tests). Could you give the exact command sequence leading to the error 
> and the result from 'mt status' before this sequence?> 
> Whatever I have tested now, I have not managed to get any messages from 
> sym53c8xx_2 (except the odd transfer error but that is transient).

Well, I have to admit that I changed the tape (got HW errors) and
everything's OK now.

James


