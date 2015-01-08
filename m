From: Andy Grover <agrover@redhat.com>
Subject: Re: [LSF/MM ATTEND] iSCSI/iSER MQ + EXTENDED_COPY host support
Date: Thu, 08 Jan 2015 10:58:29 -0800
Message-ID: <54AED355.5030705@redhat.com>
References: <1420665695.12144.62.camel@haakon3.risingtidesystems.com> <54ADAF09.8050405@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086AbbAHS6g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2015 13:58:36 -0500
In-Reply-To: <54ADAF09.8050405@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, lsf-pc <lsf-pc@lists.linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

On 01/07/2015 02:11 PM, Douglas Gilbert wrote:
> T10 have now dropped the LID1 and LID4 stuff (its the length
> of the LIST IDENTIFIER field: 1 byte or 4 bytes) by obsoleting
> all LID1 variants in SPC-5 revision 01. So the LID1 variants
> are now gone and the LID4 appendage is dropped from the remaining
> commands.
>
> Obviously LID1 based XCOPY support is important for backward
> compatibility (back to SPC-2) but for the future maybe you might
> consider adding the equivalent LID4 support for a basic XCOPY.
> For example it means using the 3PC VPD page instead of the
> RECEIVE COPY RESULTS(operating parameters) command. I believe
> FreeNAS now supports both LID1 and LID4 variants of a basic
> XCOPY (plus a restricted version of ODX without snapshots).

Hi Doug,

I was trying to learn more about ODX and saw this page:

http://msdn.microsoft.com/en-us/library/windows/desktop/hh848056%28v=vs.85%29.aspx

but it just muddied the waters for me. Is ODX proprietary to MS, or is 
it XCopy lite, or what? And what's the difference between xcopy lite and 
LID4 XCOPY?

Thanks -- Andy

