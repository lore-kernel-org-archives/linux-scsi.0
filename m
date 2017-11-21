From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: csiostor: remove unneeded DRIVER_LICENSE #define
Date: Mon, 20 Nov 2017 22:15:45 -0500
Message-ID: <yq1k1ykmie6.fsf@oracle.com>
References: <20171117142122.GF17880@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171117142122.GF17880@kroah.com> (Greg Kroah-Hartman's message
        of "Fri, 17 Nov 2017 15:21:22 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Varun Prakash <varun@chelsio.com>, linux-kernel@vger.kernel.org, Philippe Ombredanne <pombredanne@nexb.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Greg,

> There is no need to #define the license of the driver, just put it in
> the MODULE_LICENSE() line directly as a text string.
>
> This allows tools that check that the module license matches the source
> code license to work properly, as there is no need to unwind the
> unneeded dereference, especially when the string is defined in a .h file
> far away from the .c file it is used in.

Applied to 4.16/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
