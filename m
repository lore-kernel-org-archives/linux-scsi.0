From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: Limit max concurrent sessions
Date: Fri, 2 Oct 2015 19:00:45 +0200
Message-ID: <560EB83D.2000605@fastmail.fm>
References: <554A34F3.5080507@assyoma.it> <5602B511.8020502@assyoma.it>
 <20150923171848.3dd31edf@harpe.intellique.com>
 <c07f7ee2ae76d94eea580a60e3dacaa3@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54112 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846AbbJBRAr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2015 13:00:47 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id B1FFB20738
	for <linux-scsi@vger.kernel.org>; Fri,  2 Oct 2015 13:00:46 -0400 (EDT)
In-Reply-To: <c07f7ee2ae76d94eea580a60e3dacaa3@assyoma.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>, Emmanuel Florac <eflorac@intellique.com>
Cc: linux-scsi@vger.kernel.org



On 09/27/2015 12:28 PM, Gionatan Danti wrote:
> Il 23-09-2015 17:18 Emmanuel Florac ha scritto:
>>
>> Use XFS. XFS won't let you mount it several time on different machines
>> without various "force" options.
>> Alternatively, use a cluster-aware FS like ocfs2. Ocfs2 is quite easy
>> to set up.
> 
> Thank you for the suggestion.
> Unfortunately, due to specific requirements I must use EXT4.

ext4 has MMP support (multiple mount protection), you can enable it with
tune2fs.

Cheers,
Bernd
