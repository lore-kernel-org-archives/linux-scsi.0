From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Tue, 25 Mar 2003 15:29:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030325232920.GB2692@beaverton.ibm.com>
References: <20030325100704.GC3868@beaverton.ibm.com> <1048613872.2070.12.camel@mulgrave> <20030325184530.GA1202@beaverton.ibm.com> <1048618939.1790.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1048618939.1790.29.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> > 
> > The bus_for_each solution currently use a rw sema which I thought would
> > not be a good choice for these type of operations as there is a
> > possibility that we may want to call functions (offline) in interrupt
> > context.
> 
> Well...I think it's not too much of a stretch to require that additions
> to the device list be done only from user context (initial inquiry does
> that, as does scsi add/remove-single-device), so a sema can be made OK
> here.

I thought we where looking at a solution for all traversals of the list?
There are currently ~52 refs to my_devices, while some traversals can be
evalutated and possibly removed there maybe valid ones that happen
without user context.


-andmike
--
Michael Anderson
andmike@us.ibm.com

