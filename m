From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v3] xen/scsiback: add error handling for xenbus_printf
Date: Tue, 19 Jun 2018 14:52:57 +0200
Message-ID: <f16b5ad8-1748-5b80-22a9-380bca79852b@suse.com>
References: <1528775185-39467-1-git-send-email-jiazhouyang09@gmail.com>
 <1529108077-60035-1-git-send-email-jiazhouyang09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529108077-60035-1-git-send-email-jiazhouyang09@gmail.com>
Content-Language: de-DE
Sender: linux-kernel-owner@vger.kernel.org
To: Zhouyang Jia <jiazhouyang09@gmail.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 16/06/18 02:14, Zhouyang Jia wrote:
> When xenbus_printf fails, the lack of error-handling code may
> cause unexpected results.
> 
> This patch adds error-handling code after calling xenbus_printf.
> 
> Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen
