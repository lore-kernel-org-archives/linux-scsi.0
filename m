From: ojab <ojab@ojab.ru>
Subject: Re: [PATCH V2] mpt3sas: disable ASPM for MPI2 controllers
Date: Mon, 23 Jan 2017 15:59:12 +0000
Message-ID: <73a398a7-bde4-d337-0954-bc0f8d2f3752@ojab.ru>
References: <20161228110524.7516-1-ojab@ojab.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36161 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbdAWP7Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2017 10:59:16 -0500
Received: by mail-lf0-f67.google.com with SMTP id h65so14357137lfi.3
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2017 07:59:15 -0800 (PST)
In-Reply-To: <20161228110524.7516-1-ojab@ojab.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 2016/12/28 11:05, ojab wrote:
> MPI2 controllers sometimes got lost (i. e. disappears from
> /sys/bus/pci/devices) if ASMP is enabled.
>
> Signed-off-by: Slava Kardakov <ojab@ojab.ru>
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=60644

Can I haz Reviewed-by?

//wbr ojab

