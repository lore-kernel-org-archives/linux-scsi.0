From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: Limit max concurrent sessions
Date: Sun, 27 Sep 2015 12:28:41 +0200
Message-ID: <c07f7ee2ae76d94eea580a60e3dacaa3@assyoma.it>
References: <554A34F3.5080507@assyoma.it> <5602B511.8020502@assyoma.it>
 <20150923171848.3dd31edf@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mr003msb.fastweb.it ([85.18.95.87]:33962 "EHLO
	mr003msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbbI0K2p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Sep 2015 06:28:45 -0400
In-Reply-To: <20150923171848.3dd31edf@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-scsi@vger.kernel.org, g.danti@assyoma.it

Il 23-09-2015 17:18 Emmanuel Florac ha scritto:
> 
> Use XFS. XFS won't let you mount it several time on different machines
> without various "force" options.
> Alternatively, use a cluster-aware FS like ocfs2. Ocfs2 is quite easy
> to set up.

Thank you for the suggestion.
Unfortunately, due to specific requirements I must use EXT4.

So, there is no methods to limit concurrent connections?
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
