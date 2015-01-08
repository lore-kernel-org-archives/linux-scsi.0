From: Andy Grover <agrover@redhat.com>
Subject: Re: [LSF/MM ATTEND] iSCSI/iSER MQ + EXTENDED_COPY host support
Date: Thu, 08 Jan 2015 15:27:57 -0800
Message-ID: <54AF127D.7050109@redhat.com>
References: <1420665695.12144.62.camel@haakon3.risingtidesystems.com> <54ADAF09.8050405@interlog.com> <54AED355.5030705@redhat.com> <54AF0E9D.30204@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbbAHX2D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2015 18:28:03 -0500
In-Reply-To: <54AF0E9D.30204@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, lsf-pc <lsf-pc@lists.linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

On 01/08/2015 03:11 PM, Douglas Gilbert wrote:
> Andy,
> XCOPY is huge and keeps getting bigger (apart from the recent
> trimming of the "LID1" generation mentioned above). Most SCSI
> commands are sent to the LU involved, but for EXTENDED COPY
> command itself, should it be sent to the source or destination
> of the copy, or another LU which acts as a third party copy
> manager? Also when you examine the parameter block associated
> with the EXTENDED COPY command, one starts thinking there
> must be a cleaner and simpler way.
>
> In the real world VMware have been using the basic disk->disk
> XCOPY for around 10 years. Their usage seems to be dominant in
> the market place.
>
> While the LID4 rewrite/additions were occurring at T10 in 2011,
> a proposal was made to simplify things with a two step,
> disk-to-disk copy. The glue between those two steps is a token.
> The first step (POPULATE TOKEN) is sent to the copy source **,
> the second step is sent to the copy destination (WRITE USING
> TOKEN). The document is called:
>         XCOPYv2: Extended Copy Plus & Lite
> [11-077R1 at www.t10.org] and is worth looking at. The
> "Bucket Of Bytes" (BOB) in that document has become the
> "Representation Of Data" (ROD) found in T10 documents today.
>
> Commercially MS and NetApp (seemingly) were behind this
> new approach. And MS christened it ODX which is found in their
> recent OS products.
>
>
> I have written this page about the ddpt utility's
> implementation of these two disk-to-disk copy approaches:
>    http://sg.danny.cz/sg/ddpt_xcopy_odx.html

Thanks for your and nab's reply and this web page, they answer all my 
questions. I was failing to find anything on MS or vendor sites with 
this kind of info.

Thanks again -- Andy

