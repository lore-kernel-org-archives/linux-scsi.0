From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Intel SASMF8I
Date: Sat, 20 Mar 2010 09:55:02 -0400
Message-ID: <20100320135502.GA17517@infradead.org>
References: <4BA3FD3E.9070801@gmail.com> <87d699441003191546v6c0f0b89t64ab93c4e3207f37@mail.gmail.com> <4BA402F0.1040501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48863 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab0CTNzH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Mar 2010 09:55:07 -0400
Content-Disposition: inline
In-Reply-To: <4BA402F0.1040501@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marco Schindler <marco.schindler@gmail.com>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, Eric.Moore@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 12:04:16AM +0100, Marco Schindler wrote:
> SASMF8I doesn't seem to have any jumpers for "regular" mode and I don't  
> want to use the sw raid of the chip. As far as I remember megasr didn't  
> let me access drives directly. Is there no option then, except patching  
> locally?

I think we should add it in that case.  There's no reason to cripple
Linux on hardware just because the bios pretends it has some useless
fake raid capabilities.

