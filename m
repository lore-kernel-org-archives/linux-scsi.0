From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: Re: [patch] scsi: dpt_i2o: double free on error path
Date: Wed, 30 Nov 2016 21:18:03 +0100
Message-ID: <7d0c3dba-bb98-4df0-8559-fc6d09000735@gmail.com>
References: <20161130193648.GA24818@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:33814 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753868AbcK3UVf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2016 15:21:35 -0500
In-Reply-To: <20161130193648.GA24818@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org



On 11/30/2016 08:36 PM, Dan Carpenter wrote:
> We recently introduced a kfree() in the caller for this function.
> That's where, logically, you would think the kfree() should be.
> Unfortunately the code was just ugly and not buggy so the static
> checker warning was a false postive and introduced a double free.
>
oh, yes! Sorry I missed that.

Quentin
