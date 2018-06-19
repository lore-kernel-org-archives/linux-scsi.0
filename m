From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v5] scsi: xen-scsifront: add error handling for
 xenbus_printf
Date: Tue, 19 Jun 2018 14:53:36 +0200
Message-ID: <b47a3387-bc82-4030-a707-b6bb3a2ddf88@suse.com>
References: <1528774962-39173-1-git-send-email-jiazhouyang09@gmail.com>
 <1529082301-59038-1-git-send-email-jiazhouyang09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529082301-59038-1-git-send-email-jiazhouyang09@gmail.com>
Content-Language: de-DE
Sender: linux-kernel-owner@vger.kernel.org
To: Zhouyang Jia <jiazhouyang09@gmail.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 15/06/18 19:05, Zhouyang Jia wrote:
> When xenbus_printf fails, the lack of error-handling code may
> cause unexpected results.
> 
> This patch adds error-handling code after calling xenbus_printf.
> 
> Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen
