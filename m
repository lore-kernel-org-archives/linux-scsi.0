From: "N.C.Krishna Murthy" <krmurthy@cisco.com>
Subject: Re: two SCSI HBAs having same host no in Linux 2.4 kernel
Date: Wed, 17 Mar 2004 20:18:27 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200403172018.27581.krmurthy@cisco.com>
References: <200403171940.23006.krmurthy@cisco.com> <20040317144619.GG25059@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-4.cisco.com ([171.68.10.86]:26139 "EHLO
	sj-iport-4.cisco.com") by vger.kernel.org with ESMTP
	id S261532AbUCQOs4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2004 09:48:56 -0500
In-Reply-To: <20040317144619.GG25059@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: SCSI -DEVELOPERS <linux-scsi@vger.kernel.org>

Hi,
	Our iSCSI driver does use new_eh_code.
Thanx
N.C.Krishna Murthy

On Wednesday 17 Mar 2004 8:16 pm, Matthew Wilcox wrote:
> On Wed, Mar 17, 2004 at 07:40:23PM +0530, N.C.Krishna Murthy wrote:
> > In case of drivers which do not support new_eh_code, 'detect' is called
> > without any locks. Is this SMP safe?
>
> ... why aren't you using the new_eh_code?
>
> I suspect the answer is that this is part of the transition; that old
> drivers were expected to have their own lock inside ->detect and new
> ones don't.  But I wasn't around for that, so I'm not sure.
