From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH v2 09/11] lpfc: Correct oops on vport port resets
Date: Tue, 20 Dec 2016 08:51:00 -0800
Message-ID: <1529c8e5-82ad-152d-c7e8-3e5a43871c2d@broadcom.com>
References: <58586831.FyDLkYbAFDWuYypA%james.smart@broadcom.com>
 <79712a55-ff54-0c08-9cc6-28f96a421101@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35461 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752837AbcLTQvi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2016 11:51:38 -0500
Received: by mail-qk0-f169.google.com with SMTP id u25so43799657qki.2
        for <linux-scsi@vger.kernel.org>; Tue, 20 Dec 2016 08:51:03 -0800 (PST)
In-Reply-To: <79712a55-ff54-0c08-9cc6-28f96a421101@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org



On 12/20/2016 5:47 AM, Hannes Reinecke wrote:
>
> Now that is what I call a dodgy interface.
> Casting a 128-bit structure to a 64-bit structure, only to call a memset
> on the 128-bit structure in lpfc_sli4_iocb2wqe() is positively evil.
> Can't you clear up this mess by generally passing in a wqe128?
>
> Cheers,
>
> Hannes

Completely agree. Wanted to get this in now to avoid the issue, and the 
better clean up done afterward as its a bit more involved.

-- james

