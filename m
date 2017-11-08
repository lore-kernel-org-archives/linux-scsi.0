From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 01/17] lpfc: FLOGI failures are reported when connected to
 a private loop.
Date: Wed, 8 Nov 2017 10:57:49 -0800
Message-ID: <d5f1b4bd-b7e7-6cf1-13a3-653d77bed9c9@broadcom.com>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
 <20171103225628.24716-2-jsmart2021@gmail.com>
 <669a5545-35eb-5569-9d8f-d5d44268f425@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:52668 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751856AbdKHS5w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 13:57:52 -0500
Received: by mail-qt0-f180.google.com with SMTP id 31so4646087qtz.9
        for <linux-scsi@vger.kernel.org>; Wed, 08 Nov 2017 10:57:52 -0800 (PST)
In-Reply-To: <669a5545-35eb-5569-9d8f-d5d44268f425@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>

On 11/8/2017 1:05 AM, Hannes Reinecke wrote:
> Isn't that a bit excessive?
> Printing the same message _two_ times, and not providing additional info?
> Please do only duplicate message if there is new information printed;
> otherwise we might as well skip the second message.
>
> Cheers,
>
> Hannes
yep. will rework and repost.

-- james
