From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 8/12] mpt2sas - mpi headers
Date: Thu, 13 Nov 2008 14:31:48 -0700
Message-ID: <660360F4F2570145BD872F298951B17A5CBE1A2A@cosmail03.lsi.com>
References: <20081113211648.GA20581@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:59757 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbYKMVcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2008 16:32:00 -0500
In-Reply-To: <20081113211648.GA20581@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thursday, November 13, 2008 2:17 PM, Christoph Hellwig wrote:
> On Mon, Nov 03, 2008 at 01:39:41AM -0700, Eric Moore wrote:
> > This contains Common MPI (Message Passing Interface)
> Firmware Headers.
>
> Neither checkpatch.pl nor sparse don't like this one.  Please
> get rid of
> all the nasty typedefs and just use standard __le* types and
> verify with
> sparse that you have got the endianess handling right.
>

The only typedefs in the entire driver are those found in the mpi subfolder.  The mpi subfolder contains headers that define the common message passing interface between device driver/application and firmware.  These headers are provided by the firmware group to every device driver and application writer.  There have been several revisions of the headers thru out the past year or so.    I think what your asking is an entire rewrite of all these headers.   I really don't think that is a good idea.

Eric
