From: Willem Riede <osst@riede.org>
Subject: Re: Fw: [Bugme-new] [Bug 5117] New: Panic when accessing
 scsi-tapedrives with 4G-remap
Date: Fri, 26 Aug 2005 02:22:20 +0000
Message-ID: <1125022940l.13191l.3l@serve.riede.org>
References: <20050825172417.217d56af.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc12.comcast.net ([204.127.198.43]:7344 "EHLO
	rwcrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S1750765AbVHZCW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2005 22:22:28 -0400
In-Reply-To: <20050825172417.217d56af.akpm@osdl.org> (from akpm@osdl.org on
	Thu Aug 25 20:24:17 2005)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Kai.Makisara@kolumbus.fi, JF@vanbaarlen.demon.nl, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@kernel-bugs.osdl.org>

On 08/25/2005 08:24:17 PM, Andrew Morton wrote:
> 
> Subject: [Bugme-new] [Bug 5117] New: Panic when accessing scsi-tapedrives  
> with 4G-remap
> 
> 
>  http://bugzilla.kernel.org/show_bug.cgi?id=5117
> 
>             Summary: Panic when accessing scsi-tapedrives with 4G-remap
>      Kernel Version: 2.6.12.5
> 
> 
> Could this purely be a highmem problem?   Is the zero-copy DMA feature of
> st.c known to work OK with x86 highmem?

I don't know about Kai, but I don't have the hardware to test that...

Sorry, Willem Riede.

