From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: SCSI TMF processing; tag allocation
Date: Tue, 16 Nov 2010 23:28:53 +0300
Message-ID: <4CE2E985.4050102@vlnb.net>
References: <380694.87733.qm@web31812.mail.mud.yahoo.com> <20101113123750.GF18258@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101113123750.GF18258@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Luben Tuikov <ltuikov@yahoo.com>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jaxboe@fusionio.com>
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox, on 11/13/2010 03:37 PM wrote:
> SPC-4 seems to indicate (in the INQUIRY command, 6.4.2) that support
> for queueing is now non-optional, and even support for basic queueing
> has been removed, replaced only with the 'command management model'.
> I must confess to being somewhat confused by the difference between the
> 'basic queue' model and 'command management' model

The 'command management model' is what was called 'full task management
model' in SAM-3. The difference of it with 'basic task management model'
in SAM-3 is that (basically) in the latter:

 - Support only for SIMPLE or ORDERED commands (not both)

 - For SIMPLE commands their reorder can't be controlled

 - On any error all queued commands must be aborted and this behavior
can't be controlled.

Vlad
