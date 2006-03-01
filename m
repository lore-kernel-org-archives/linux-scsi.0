From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: sg regression in 2.6.16-rc5
Date: Wed, 1 Mar 2006 09:38:24 +0100
Message-ID: <20060301083824.GA9871@merlin.emma.line.org>
References: <E94491DE-8378-41DC-9C01-E8C1C91B6B4E@mac.com> <4404AA2A.5010703@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:27045 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932622AbWCAIi3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2006 03:38:29 -0500
Content-Disposition: inline
In-Reply-To: <4404AA2A.5010703@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Mark Rustad <mrustad@mac.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>

On Tue, 28 Feb 2006, Douglas Gilbert wrote:

> You can stop right there with the 1 MB reads. Welcome
> to the new, blander sg driver which now shares many
> size shortcomings with the block subsystem.

What is the reason to break user-space applications like this?

-- 
Matthias Andree
