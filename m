From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 0/2] scsi: Fix endless loop of ATA hard resets due to VPD
 reads
Date: Wed, 3 Feb 2016 08:48:09 +0200
Message-ID: <20160203064808.GA10548@node.shutemov.name>
References: <20160121063039.3803.66.stgit@localhost.localdomain>
 <20160202101830.GA3786@node.shutemov.name>
 <yq1fuxamrz7.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33622 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbcBCGsM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 01:48:12 -0500
Received: by mail-wm0-f65.google.com with SMTP id r129so5890303wmr.0
        for <linux-scsi@vger.kernel.org>; Tue, 02 Feb 2016 22:48:12 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <yq1fuxamrz7.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alexander Duyck <aduyck@mirantis.com>, jbottomley@odin.com, hare@suse.de, linux-scsi@vger.kernel.org, alexander.duyck@gmail.com, linux-kernel@vger.kernel.org, shane.seymour@hpe.com, jthumshirn@suse.de

On Tue, Feb 02, 2016 at 09:45:48PM -0500, Martin K. Petersen wrote:
> >>>>> "Kirill" == Kirill A Shutemov <kirill@shutemov.name> writes:
> 
> Kirill> I have the same problem.
> 
> Kirill> Shouldn't we put quirk for that?
> 
> I was hoping that Hannes' patch would do the trick so we could avoid
> blacklisting:
> 
> 	https://patchwork.kernel.org/patch/8079011/

It didn't help me.

-- 
 Kirill A. Shutemov
