From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: request_buffer versus buffer in Scsi_Cmnd
Date: Fri, 27 Sep 2002 09:29:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020927162938.GA1366@beaverton.ibm.com>
References: <200209270915.CAA96467@classic.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200209270915.CAA96467@classic.engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Cc: linux-scsi@vger.kernel.org


Jeremy Higdon [jeremy@classic.engr.sgi.com] wrote:
> I notice that the qlogicfc driver calls pci_map_sg with the request_buffer
> field and pci_unmap_sg with the buffer field.
> 
> >From looking at the code in drivers/scsi/scsi*, it would appear that they
> are mostly the same, and the fact that qlogicfc works would seem to confirm
> that.  However, the fact that there are two different fields leads me
> to ask what the difference is supposed to be.
> 

There are a few fields in the Scsi_Cmnd that are duplicated to contain
the original values that the scsi cmd was submitted with mostly for retry.

Some Pairs:
	request_buffer, buffer
	request_bufflen, bufflen
	use_sg, old_use_sg
	etc.

a few more are listed in the scsi_retry_command.

-andmike
--
Michael Anderson
andmike@us.ibm.com

