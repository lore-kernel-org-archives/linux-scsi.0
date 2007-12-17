From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: INITIO scsi driver fails to work properly
Date: Mon, 17 Dec 2007 16:13:53 +0000
Message-ID: <20071217161353.0928b112@the-village.bc.nu>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	<20071217031841.f483e5ac.akpm@linux-foundation.org>
	<20071217130523.7e9c88bb@the-village.bc.nu>
	<47668A75.7040707@panasas.com>
	<20071217143641.760d4162@the-village.bc.nu>
	<1197903781.3204.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S935425AbXLQQVt@vger.kernel.org>
In-Reply-To: <1197903781.3204.4.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Filippos Papadopoulos <psybases@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> Well, the change log isn't very committal for "rush me immediately into
> main line" plus, as far as I could dig out, there was no confirmation
> that it actually worked.  This way, I can now say please try the current

Without that change it always tries to use zero as the memory/io address
of the device.
