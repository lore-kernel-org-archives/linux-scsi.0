From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: question on highmem support in lldd
Date: Sun, 13 Nov 2005 09:03:31 +0100
Message-ID: <1131869012.2833.2.camel@laptopd505.fenrus.org>
References: <200511130851.27000.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:20177 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964907AbVKMIDj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 03:03:39 -0500
In-Reply-To: <200511130851.27000.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-scsi@vger.kernel.org

On Sun, 2005-11-13 at 08:51 +0100, Oliver Neukum wrote:
> Hi,
> 
> could somebody point me to a summary describing how highmem
> is supported and how to indicate to higher layers which type of memory
> is supported?

if you set the proper dma mask to what your device is capable of, then
the kernel takes care of the rest for you.


