From: Philippe Ombredanne <pombredanne@nexb.com>
Subject: Re: [PATCH] scsi: csiostor: remove unneeded DRIVER_LICENSE #define
Date: Fri, 17 Nov 2017 15:54:24 +0100
Message-ID: <CAOFm3uHkAzutA+U8Fn_mcwfvj3SUzb66-TPXquz0UFqe2QL8eQ@mail.gmail.com>
References: <20171117142122.GF17880@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32996 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758445AbdKQOzG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Nov 2017 09:55:06 -0500
Received: by mail-wm0-f65.google.com with SMTP id g130so3721956wme.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Nov 2017 06:55:05 -0800 (PST)
In-Reply-To: <20171117142122.GF17880@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Varun Prakash <varun@chelsio.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Fri, Nov 17, 2017 at 3:21 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> There is no need to #define the license of the driver, just put it in
> the MODULE_LICENSE() line directly as a text string.
>
> This allows tools that check that the module license matches the source
> code license to work properly, as there is no need to unwind the
> unneeded dereference, especially when the string is defined in a .h file
> far away from the .c file it is used in.
>
> Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Varun Prakash <varun@chelsio.com>
> Reported-by: Philippe Ombredanne <pombredanne@nexb.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


Reviewed-by: Philippe Ombredanne <pombredanne@nexb.com>
-- 
Cordially
Philippe Ombredanne
