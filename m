From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Thu, 07 Oct 2004 16:35:43 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <4165A89F.20900@pobox.com>
References: <4161A06D.8010601@rtr.ca> <416547B6.5080505@rtr.ca> <20041007150709.B12688@infradead.org> <4165624C.5060405@rtr.ca> <416565DB.4050006@pobox.com> <4165A45D.2090200@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S268136AbUJGUii@vger.kernel.org>
In-Reply-To: <4165A45D.2090200@rtr.ca>
To: Mark Lord <lsml@rtr.ca>
Cc: Mark Lord <lkml@rtr.ca>, Christoph Hellwig <hch@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Maybe I can put it another way.

Without seeing the code that uses the hooks, we cannot evaluate whether 
the hooks are needed, useful, or even properly implemented.  They are 
unreviewable.

Does this same argument hold true for ioctls?  Yes.  But (as noted in 
the previous email) ioctls and kernel API hooks are quite different.

	Jeff
